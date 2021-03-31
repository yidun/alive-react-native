
import { NativeModules } from 'react-native';
import { requireNativeComponent } from 'react-native';

export default NativeModules.AliveHelper;
module.exports = requireNativeComponent('NTESRNLiveDetect');
