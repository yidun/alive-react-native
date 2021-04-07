
# 易盾活体检测RN接入使用文档
在使用前请确保已申请到易盾活体检测的业务id

## 导入插件
```
npm install --save https://github.com/yidun/alive-react-native.git
react-native link react-native-alive-view
```
也可以直接使用
```
npm install react-native-alive-view
```

## 配置依赖(Android必须)
在react-native工程对应的android/app/build.gradle 文件的android域中添加
```
 repositories {
        flatDir {
            dirs project(':react-native-alive-view').file('libs')
        }
    }

    packagingOptions {
        pickFirst  'lib/x86/libc++_shared.so'
        pickFirst  'lib/arm64-v8a/libc++_shared.so'
        pickFirst  'lib/x86_64/libc++_shared.so'
        pickFirst  'lib/armeabi-v7a/libc++_shared.so'
    }
    
    权限配置
    <uses-feature android:name="android.hardware.camera" />   //需要动态申请
    <uses-feature android:name="android.hardware.camera.autofocus" />
    <uses-feature android:name="android.hardware.camera.front" />
    <uses-feature android:name="android.hardware.camera.front.autofocus" />

    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

## 引入
### 活体view
```js
import {requireNativeComponent} from 'react-native'
const NTESRNLiveDetectView = requireNativeComponent('NTESRNLiveDetect');
```
回调
```js
onActionChange: (e: {nativeEvent: {actions: string}}) => void;
onWarnChange: (e: {nativeEvent: {message?: string}}) => void;
onStepChange: (e: {
    nativeEvent: {message?: string; currentStep: number};
  }) => void;
  onResultChange: (e: {
    nativeEvent: {message?: string; token?: string};
  }) => void;
```

### 活体检测操作

```js
import {NativeModules} from 'react-native';
```

然后就可以使用原生模块NativeModules获取易盾活体检测RN对象
```js
const AliveHelper = NativeModules.AliveHelper;
```

## 活体检测API说明

### initWithBusinessID(String businessId,int timeOut)
*方法描述：*
初始化
参数:businessId 易盾业务id timeOut 超时时间（单位秒）

### startAlive()
*方法描述：*
开始活体检测

### stopAlive()
*方法描述：*
关闭活体检测

### 详见Demo
https://github.com/yidun/alive-reactnative-plugin
