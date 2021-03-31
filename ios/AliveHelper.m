//
//  AliveHelper.m
//  liveDetectDemo
//
//  Created by 罗礼豪 on 2020/11/16.
//

#import "AliveHelper.h"
#import "NTESRNLiveDetectView.h"

@implementation AliveHelper


// 标记宏（必要）
RCT_EXPORT_MODULE(AliveHelper)

/**
 *  相机开始工作
 */
RCT_EXPORT_METHOD(startAlive) {
  [[NTESRNLiveDetectView sharedInstance] startLiveDetect];
}

/**
 *  相机开始工作
 */
RCT_EXPORT_METHOD(stopAlive) {
  [[NTESRNLiveDetectView sharedInstance] stopDetect];
}


@end
