//
//  NTESRNLiveDetecrManager.m
//  verifyCodeRNDemo
//
//  Created by 罗礼豪 on 2020/8/25.
//

#import "NTESRNLiveDetectManager.h"
#import <React/RCTComponent.h>
#import "NTESRNLiveDetectView.h"

@interface NTESRNLiveDetectManager()

@property (nonatomic, strong) NTESRNLiveDetectView *imageView;

@end

@implementation NTESRNLiveDetectManager

// 标记宏（必要）
RCT_EXPORT_MODULE(NTESRNLiveDetect)

- (UIView *)view {
  NTESRNLiveDetectView *imageView = [NTESRNLiveDetectView sharedInstance];
//  [imageView startLiveDetect];
//  imageView.backgroundColor = [UIColor whiteColor];
  return imageView;
}

// 回调事件
RCT_EXPORT_VIEW_PROPERTY(onActionChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onWarnChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStepChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onResultChange, RCTBubblingEventBlock)


@end
