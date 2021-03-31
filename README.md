
# 易盾活体检测RN接入使用文档
在使用前请确保已申请到易盾活体检测的业务id

## 导入插件
```
npm install --save https://github.com/yidun/alive-react-native.git
react-native link react-native-alive-view
```
## 配置依赖
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
```

## 引入
```js
import {NativeModules} from 'react-native';
```

然后就可以使用原生模块NativeModules获取易盾活体检测RN对象NativeModules.RNAliveView

## 活体检测API说明

### startAlive()
*方法描述：*
开始活体检测

*参数说明：*
```
businessId: '从易盾申请的id',
callback -- 初始化结果回调

// 返回参数
success: 初始化是否成功
