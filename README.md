# 活体检测
根据提示做出相应动作，SDK 实时采集动态信息，判断用户是否为活体、真人

## 平台支持（兼容性）
  | Android|iOS|  
  | ---- | ----- |
  | 适用版本区间：4.4以上|适用版本区间：9 - 14| 

## 环境准备

[CocoaPods安装教程](https://guides.cocoapods.org/using/getting-started.html)

## 资源引入/集成
```
npm install @yidun/livedetect-plugin-rn
```

### 项目开发配置

#### Android 配置
在 react-native 工程对应的 android/app/build.gradle 文件的 android 域中添加
```
defaultConfig {
    ndk {
        abiFilters "armeabi-v7a","arm64-v8a" //必须添加，否则部分cpu架构机型异常
    }   
}

repositories {
    flatDir {
        dirs project(':yidun_livedetect-plugin-rn').file('libs')
    }
}

packagingOptions {
    pickFirst  'lib/arm64-v8a/libc++_shared.so'
    pickFirst  'lib/armeabi-v7a/libc++_shared.so'
}
```
插件依赖CAMERA权限，6.0 及以上需要动态申请。动态申请的权限可以借助于 react-native 的 PermissionsAndroid 申请
```
const requestCameraPermission = async () => {
  try {
    const granted = await PermissionsAndroid.request(
      PermissionsAndroid.PERMISSIONS.CAMERA,
      {
        title: "Cool Photo App Camera Permission",
        message:
          "Cool Photo App needs access to your camera " +
          "so you can take awesome pictures.",
        buttonNeutral: "Ask Me Later",
        buttonNegative: "Cancel",
        buttonPositive: "OK"
      }
    );
    if (granted === PermissionsAndroid.RESULTS.GRANTED) {
      console.log("You can use the camera");
    } else {
      console.log("Camera permission denied");
    }
  } catch (err) {
    console.warn(err);
  }
};
```

release 包需要添加混淆规则

```
-keep class com.netease.nis.alivedetected.entity.*{*;}
-keep class com.netease.nis.alivedetected.AliveDetector  {
    public <methods>;
    public <fields>;
}
-keep class com.netease.nis.alivedetected.DetectedEngine{
    native <methods>;
}
-keep class com.netease.nis.alivedetected.NISCameraPreview  {
    public <methods>;
}
-keep class com.netease.nis.alivedetected.DetectedListener{*;}
-keep class com.netease.nis.alivedetected.ActionType{ *;}
```

#### iOS 配置
在 flutter 工程对应的 example/ios/Runner/info.plist 里 ，添加
```
<key>NSPhotoLibraryUsageDescription</key> 
<string></string> 
<key>NSCameraUsageDescription</key>
<string></string>

```

## 调用示例

```
import React, {Component} from 'react';
import {
    SafeAreaView,
    requireNativeComponent,
    NativeModules,
    Button
} from 'react-native';

const AliveHelper = NativeModules.AliveHelper;
const NTESRNLiveDetectView = requireNativeComponent('NTESRNLiveDetect');

class Demo extends Component {
    render() {
        return (
            <SafeAreaView style={{flex: 1}}>
                <Button onPress={() => AliveHelper.initWithBusinessID('易盾业务id', 30,)} title="初始化SDK"/>
                <Button onPress={() => AliveHelper.startAlive()} title="开始活体检测"/>
                <NTESRNLiveDetectView
                    style={
                        {
                            width: 250,
                            height: 250,
                            borderRadius: 125,
                            overflow: 'hidden',
                            backgroundColor: '#ffffff',
                            justifyContent: 'center',
                            alignItems: 'center',
                        }
                    }
                />
            </SafeAreaView>
        )
    }
}
```
更多使用场景请参考 [demo](https://github.com/yidun/alive_react_demo)

## SDK 方法说明

### 1 初始化

#### 代码说明：
```
import {NativeModules} from 'react-native';
const AliveHelper = NativeModules.AliveHelper;//对象创建
AliveHelper.initWithBusinessID('businessId', timeout);
```

#### 参数说明：
*  options基础参数：

   |参数|类型|是否必填|默认值| 描述         |
   |----|----|--------|------------|----|
   |businessId|String|是|无| 易盾分配的业务id  |
   |timeout|Number|是|30秒| 活体检测超时时间/s |

### 2 开始活体检测验证

#### 代码说明：
```
AliveHelper.startAlive()
```

### 3 停止活体检测

#### 代码说明：
```
AliveHelper.stopAlive();
```
### 4 检测状态监听

以下4个监听在 iOS 上生效，在 Android 不生效
```
onActionChange={(e) => handleActionChange(e.nativeEvent)} onWarnChange={(e) => handleWarnChange(e.nativeEvent)}
onStepChange={(e) => handleStepChange(e.nativeEvent)}
onResultChange={(e) => handleResultChange(e.nativeEvent)}
```

以下监听在 Android 上生效，在 iOS 上不生效
```
import {DeviceEventEmitter} from 'react-native';
useEffect(() => {
    const actionListener = DeviceEventEmitter.addListener(
    'onActionChange',
    handleActionChange,
);
const warnListener = DeviceEventEmitter.addListener(
    'onWarnChange',
    handleWarnChange,
);
const stepListener = DeviceEventEmitter.addListener(
    'onStepChange',
    handleStepChange,
);
const resultListener = DeviceEventEmitter.addListener(
    'onResultChange',
    handleResultChange,
);

return () => {
    actionListener.remove();
    warnListener.remove();
    stepListener.remove();
    resultListener.remove();
};
  }, [handleResultChange]);
```
*  监听回调说明

   |回调字段|类型|描述|
    |---|----|-----|
    | actions |String|检测动作 0：正视前方 1：向右转头 2：向左转头 3：张嘴动作 4：眨眼动作，例如：actions = "123",表示需要做向右转头、向左转头、张嘴动作三个动作|
	| currentStep|Number|检查动作 0：正视前方 1：向右转头 2：向左转头 3：张嘴动作 4：眨眼动作|
  	| exception|String|异常状态 1：保持面部在框内 2：环境光线过暗 3：环境光线过亮 4：请勿抖动手机|
  	| message|String|人脸识别检测通过; 人脸识别检测未通过,操作超时; 用户未在规定时间内完成动作; 活体检测获取配置信息超时; 云端检测结果请求超时; 云端检测上传图片失败; 网络未连接; App未获取相机权限"|
	