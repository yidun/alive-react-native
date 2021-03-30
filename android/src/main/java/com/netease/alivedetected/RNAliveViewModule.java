
package com.netease.alivedetected;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.netease.nis.alivedetected.AliveDetector;

public class RNAliveViewModule extends ReactContextBaseJavaModule {
    public RNAliveViewModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @ReactMethod
    public void startAlive() {
        AliveDetector.getInstance().startDetect();
    }

    @ReactMethod
    public void stopAlive() {
        AliveDetector.getInstance().stopDetect();
    }

    @Override
    public String getName() {
        return "RNAliveView";
    }
}