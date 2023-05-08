
package com.netease.alivedetected;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.netease.nis.alivedetected.AliveDetector;

public class RNAliveViewModule extends ReactContextBaseJavaModule {
    private final ReactContext reactContext;
    private final AliveHelper aliveHelper;

    public RNAliveViewModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        aliveHelper = AliveHelper.getInstance();
    }

    @ReactMethod
    public void initWithBusinessID(String businessId, int timeOut) {
        aliveHelper.init(reactContext, businessId, timeOut);
    }

    @ReactMethod
    public void startAlive() {
        aliveHelper.startDetected();
    }

    @ReactMethod
    public void stopAlive() {
        aliveHelper.stopDetected();
    }

    @Override
    public String getName() {
        return "AliveHelper";
    }
}