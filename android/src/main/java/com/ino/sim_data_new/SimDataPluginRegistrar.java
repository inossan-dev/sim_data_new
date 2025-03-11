package com.ino.sim_data_new;

import io.flutter.plugin.common.PluginRegistry;

public final class SimDataPluginRegistrar {
    public static void registerWith(PluginRegistry registry) {
        if (alreadyRegisteredWith(registry)) {
            return;
        }
        SimDataPlugin.registerWith(registry.registrarFor("com.ino.sim_data_new.SimDataPlugin"));
    }

    private static boolean alreadyRegisteredWith(PluginRegistry registry) {
        final String key = SimDataPluginRegistrar.class.getCanonicalName();
        if (registry.hasPlugin(key)) {
            return true;
        }
        registry.registrarFor(key);
        return false;
    }
}