package com.ino.sim_data_new;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener;
import java.util.List;
import java.util.ArrayList;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * SimDataPlugin
 */
public class SimDataPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, RequestPermissionsResultListener {

  public static final String CHANNEL_NAME = "com.ino.sim_data_new/channel_name";
  private static final int REQUEST_CODE_PHONE_STATE = 2001;
  private Context applicationContext;
  private Activity activity;
  private MethodChannel channel;
  private Result pendingResult;
  private MethodCall pendingCall;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.initialize(flutterPluginBinding.getBinaryMessenger(),
            flutterPluginBinding.getApplicationContext());
  }

  private void initialize(BinaryMessenger messenger, Context context) {
    this.applicationContext = context;
    channel = new MethodChannel(messenger, CHANNEL_NAME);
    channel.setMethodCallHandler(this);
  }

  public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    SimDataPlugin instance = new SimDataPlugin();
    instance.initialize(registrar.messenger(), registrar.context());
    if (registrar.activity() != null) {
      instance.activity = registrar.activity();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    channel = null;
    this.applicationContext = null;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getSimData")) {
      if (!checkPermission()) {
        pendingResult = result;
        pendingCall = call;
        requestPermission();
        return;
      }

      try {
        String simCards = getSimData().toString();
        result.success(simCards);
      } catch (Exception e) {
        result.error("SimData_error", e.getMessage(), e.getStackTrace());
      }
    } else {
      result.notImplemented();
    }
  }

  private JSONObject getSimData() throws Exception {
    if (activity == null) {
      throw new Exception("Activity is null");
    }

    SubscriptionManager subscriptionManager = (SubscriptionManager) this.applicationContext
            .getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE);

    // Check permission again as a safeguard
    if (ContextCompat.checkSelfPermission(applicationContext, Manifest.permission.READ_PHONE_STATE)
            != PackageManager.PERMISSION_GRANTED) {
      throw new Exception("READ_PHONE_STATE permission not granted");
    }

    List<SubscriptionInfo> subscriptionInfos = subscriptionManager.getActiveSubscriptionInfoList();

    // Handle null safely
    if (subscriptionInfos == null) {
      subscriptionInfos = new ArrayList<>();
    }

    JSONArray cards = new JSONArray();
    for (SubscriptionInfo subscriptionInfo : subscriptionInfos) {
      int slotIndex = subscriptionInfo.getSimSlotIndex();

      CharSequence carrierName = subscriptionInfo.getCarrierName();
      String countryIso = subscriptionInfo.getCountryIso();
      int dataRoaming = subscriptionInfo.getDataRoaming();  // 1 is enabled ; 0 is disabled
      CharSequence displayName = subscriptionInfo.getDisplayName();
      String serialNumber = subscriptionInfo.getIccId();
      int mcc = subscriptionInfo.getMcc();
      int mnc = subscriptionInfo.getMnc();
      boolean networkRoaming = subscriptionManager.isNetworkRoaming(subscriptionInfo.getSubscriptionId());
      String phoneNumber = subscriptionInfo.getNumber();
      int subscriptionId = subscriptionInfo.getSubscriptionId();

      JSONObject card = new JSONObject();

      card.put("carrierName", carrierName != null ? carrierName.toString() : "");
      card.put("countryCode", countryIso != null ? countryIso : "");
      card.put("displayName", displayName != null ? displayName.toString() : "");
      card.put("isDataRoaming", (dataRoaming == 1));
      card.put("isNetworkRoaming", networkRoaming);
      card.put("mcc", mcc);
      card.put("mnc", mnc);
      card.put("phoneNumber", phoneNumber != null ? phoneNumber : "");
      card.put("serialNumber", serialNumber != null ? serialNumber : "");
      card.put("slotIndex", slotIndex);
      card.put("subscriptionId", subscriptionId);

      cards.put(card);
    }

    JSONObject simCards = new JSONObject();
    simCards.put("cards", cards);

    return simCards;
  }

  private void requestPermission() {
    if (activity == null) {
      if (pendingResult != null) {
        pendingResult.error("SimData_error", "Activity is null", null);
        pendingResult = null;
        pendingCall = null;
      }
      return;
    }

    String[] perm = {Manifest.permission.READ_PHONE_STATE};
    ActivityCompat.requestPermissions(activity, perm, REQUEST_CODE_PHONE_STATE);
  }

  private boolean checkPermission() {
    return PackageManager.PERMISSION_GRANTED == ContextCompat
            .checkSelfPermission(applicationContext, Manifest.permission.READ_PHONE_STATE);
  }

  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    if (requestCode == REQUEST_CODE_PHONE_STATE && pendingResult != null) {
      if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        try {
          String simCards = getSimData().toString();
          pendingResult.success(simCards);
        } catch (Exception e) {
          pendingResult.error("SimData_error", e.getMessage(), e.getStackTrace());
        }
      } else {
        pendingResult.error("SimData_error", "Permission denied", null);
      }
      pendingResult = null;
      pendingCall = null;
      return true;
    }
    return false;
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    binding.addRequestPermissionsResultListener(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    this.activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    binding.addRequestPermissionsResultListener(this);
  }

  @Override
  public void onDetachedFromActivity() {
    this.activity = null;
  }
}