package com.netease.alivedetected;

import android.content.Context;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.netease.nis.alivedetected.ActionType;
import com.netease.nis.alivedetected.AliveDetector;
import com.netease.nis.alivedetected.DetectedListener;
import com.netease.nis.alivedetected.NISCameraPreview;

/**
 * Created by hzhuqi on 2020/8/31
 */
public class AliveHelper {
    public static final String TAG = "RNAlive";
    private ReactContext reactContext;
    private NISCameraPreview cameraPreview;
    private static final AliveHelper aliveHelper = new AliveHelper();

    private AliveHelper() {
    }

    public static AliveHelper getInstance() {
        return aliveHelper;
    }

    public void setPreView(NISCameraPreview cameraPreview) {
        this.cameraPreview = cameraPreview;
    }

    public void init(ReactContext reactContext, String businessId, int timeOut) {
        this.reactContext = reactContext;
        if (cameraPreview != null) {
            AliveDetector.getInstance().init(reactContext, cameraPreview, businessId);
            AliveDetector.getInstance().setTimeOut(timeOut);
        }
    }

    public void startDetected() {
        AliveDetector.getInstance().startDetect();
        AliveDetector.getInstance().setDetectedListener(new DetectedListener() {
            @Override
            public void onReady(boolean b) {

            }

            @Override
            public void onActionCommands(ActionType[] actionTypes) {
                Log.d(TAG, "动作序列--------->" + buildActionCommand(actionTypes));
                WritableMap event = Arguments.createMap();
                event.putString("actions", buildActionCommand(actionTypes));
                sendEvent("onActionChange", event);
            }

            @Override
            public void onStateTipChanged(ActionType actionType, String stateTip) {
                int currentIndex = Integer.parseInt(actionType.getActionID());
                if (currentIndex >= 0 && currentIndex <= 4) {
                    Log.d(TAG, "动作类型--------->" + actionType.getActionTip());
                    WritableMap event = Arguments.createMap();
                    event.putString("message", actionType.getActionTip());
                    event.putInt("currentStep", currentIndex);
                    sendEvent("onStepChange", event);
                } else if (currentIndex == 5) {
                    Log.d(TAG, "状态提示--------->" + stateTip);
                    WritableMap event = Arguments.createMap();
                    event.putString("message", stateTip);
                    sendEvent("onWarnChange", event);
                }
            }

            @Override
            public void onPassed(boolean isPassed, String token) {
                WritableMap event = Arguments.createMap();
                if (isPassed) {
                    event.putString("message", "success");
                } else {
                    event.putString("message", "failed");
                }
                event.putString("token", token);
                sendEvent("onResultChange", event);
            }

            @Override
            public void onError(int code, String msg, String token) {
                WritableMap event = Arguments.createMap();
                event.putString("message", msg);
                event.putString("token", token);
                sendEvent("onWarnChange", event);
            }

            @Override
            public void onOverTime() {
                WritableMap event = Arguments.createMap();
                event.putString("message", "操作超时，用户未在规定时间内完成动作");
                event.putString("token", "");
                sendEvent("onResultChange", event);
            }
        });
    }

    public void stopDetected() {
        AliveDetector.getInstance().stopDetect();
    }

    public void destroy() {
        AliveDetector.getInstance().destroy();
    }

    private void sendEvent(String eventName, WritableMap event) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(
                eventName, event);
    }


    private String buildActionCommand(ActionType[] actionCommands) {
        StringBuilder commands = new StringBuilder();
        for (ActionType actionType : actionCommands) {
            commands.append(actionType.getActionID());
        }
        return commands == null ? "" : commands.toString();
    }

}
