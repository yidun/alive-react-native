package com.netease.alivedetected;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.widget.FrameLayout;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.netease.nis.alivedetected.NISCameraPreview;

/**
 * Created by hzhuqi on 2020/8/21
 */
public class RNAliveViewManager extends SimpleViewManager<FrameLayout> {
    private static final String NAME = "NTESRNLiveDetect";

    @Override
    public String getName() {
        return NAME;
    }

    @Override
    protected FrameLayout createViewInstance(ThemedReactContext reactContext) {
        Log.d(AliveHelper.TAG, "======createViewInstance======");
        Context context = reactContext.getApplicationContext();
        FrameLayout cameraPreview = (FrameLayout) LayoutInflater.from(reactContext).inflate(getLayoutId(context), null);
        NISCameraPreview aliveView = cameraPreview.findViewById(R.id.surface_view);
        AliveHelper.getInstance().setPreView(aliveView);
        return cameraPreview;
    }

    @Override
    public void onDropViewInstance(FrameLayout preview) {
        Log.d(AliveHelper.TAG, "======onDropViewInstance======");

        AliveHelper.getInstance().stopDetected();
        AliveHelper.getInstance().destroy();
    }

    private int getLayoutId(Context context) {
        return context.getResources().getIdentifier("preview_layout", "layout", context.getPackageName());
    }
}
