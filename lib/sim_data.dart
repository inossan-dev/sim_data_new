import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './sim_model.dart';

export './sim_model.dart';

class SimDataPlugin {
  static const String channelName = "com.ino.sim_data_new/channel_name";
  static const MethodChannel _channel = MethodChannel(channelName);

  /// Récupère les données des cartes SIM disponibles
  ///
  /// Retourne un objet [SimData] contenant la liste des cartes SIM
  /// Lève une exception [PlatformException] en cas d'erreur
  static Future<SimData> getSimData() async {
    try {
      final dynamic simData = await _channel.invokeMethod('getSimData');
      final data = json.decode(simData);
      return SimData.fromJson(data);
    } on PlatformException catch (e) {
      debugPrint('SimDataPlugin failed to retrieve data: ${e.message}');
      rethrow;
    }
  }
}