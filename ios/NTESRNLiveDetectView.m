//
//  NTESRNLiveDetecrView.m
//  liveDetectDemo
//
//  Created by 罗礼豪 on 2020/8/25.
//

#import "NTESRNLiveDetectView.h"

@interface NTESRNLiveDetectView()

@property (nonatomic, strong) NTESLiveDetectManager *detector;
@property (nonatomic, copy) NSDictionary *params;

@end
@implementation NTESRNLiveDetectView

+ (NTESRNLiveDetectView *)sharedInstance {
    static dispatch_once_t onceToken = 0;
    static NTESRNLiveDetectView *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[NTESRNLiveDetectView alloc] init];
    });
    
    return sharedObject;
}

- (void)startLiveDetect {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self stopDetect];
    self.detector = [[NTESLiveDetectManager alloc] initWithImageView:self withDetectSensit:NTESSensitEasy];
          
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveDetectStatusChange:) name:@"NTESLDNotificationStatusChange" object:nil];
    
     [self.detector setTimeoutInterval:30];
     __weak __typeof(self)weakSelf = self;
     [self.detector startLiveDetectWithBusinessID:@"74cb47d7d3174aadb75f4067f0280169" actionsHandler:^(NSDictionary * _Nonnull params) {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *actions = [params objectForKey:@"actions"];
             if (actions && actions.length != 0) {
//                 NSLog(@"动作序列：%@", actions);
               if ([NTESRNLiveDetectView sharedInstance].onActionChange) {
                 [NTESRNLiveDetectView sharedInstance].onActionChange(@{
                     @"actions": actions? : @""
                   });
               }
             } else {
             }
         });
     } completionHandler:^(NTESLDStatus status, NSDictionary * _Nullable params) {
         dispatch_async(dispatch_get_main_queue(), ^{
           weakSelf.params = params;
             [weakSelf showToastWithLiveDetectStatus:status];
         });
     }];
  });
}

- (void)stopDetect {
    [self.detector stopLiveDetect];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)liveDetectStatusChange:(NSNotification *)infoNotification {
    NSDictionary *userInfo = infoNotification.userInfo;
    NSLog(@"userInfo：%@", userInfo);
    NSString *value = [userInfo objectForKey:@"exception"];
    NSDictionary *infoDict = [userInfo objectForKey:@"action"];
    NSNumber *key = [[infoDict allKeys] firstObject];
    if (value) {
        NSString *statusText = @"";
        switch ([value intValue]) {
            case 1:
                statusText = @"保持面部在框内";
                break;
            case 2:
                statusText = @"环境光线过暗";
                break;
            case 3:
                statusText = @"环境光线过亮";
                break;
            case 4:
                statusText = @"请勿抖动手机";
                break;
            default:
                statusText = @"";
                break;
            }
      
        if ([NTESRNLiveDetectView sharedInstance].onWarnChange) {
          [NTESRNLiveDetectView sharedInstance].onWarnChange(@{
              @"message": statusText,
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(){

        });
        return;
    }
    switch ([key intValue]) {
        case 0:
            if ([NTESRNLiveDetectView sharedInstance].onStepChange) {
              [NTESRNLiveDetectView sharedInstance].onStepChange(@{
                    @"currentStep": @(0),
                    @"message": @("请正对手机屏幕"),
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){

            });
            break;
        case 1:
            if ([NTESRNLiveDetectView sharedInstance].onStepChange) {
              [NTESRNLiveDetectView sharedInstance].onStepChange(@{
                    @"currentStep": @(1),
                    @"message": @("慢慢右转头"),
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){

            });
            break;
        case 2:
            if ([NTESRNLiveDetectView sharedInstance].onStepChange) {
              [NTESRNLiveDetectView sharedInstance].onStepChange(@{
                    @"currentStep": @(2),
                    @"message": @("慢慢左转头"),
                });
              }
              dispatch_async(dispatch_get_main_queue(), ^(){
      
              });
              break;
        case 3:
            if ([NTESRNLiveDetectView sharedInstance].onStepChange) {
              [NTESRNLiveDetectView sharedInstance].onStepChange(@{
                    @"currentStep": @(3),
                    @"message": @("请张张嘴"),
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
    
            });
            break;
        case 4:
            if ([NTESRNLiveDetectView sharedInstance].onStepChange) {
              [NTESRNLiveDetectView sharedInstance].onStepChange(@{
                    @"currentStep": @(4),
                    @"message": @("请眨眨眼"),
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
    
            });
            break;
        case -1:
            break;
        default:
            break;
       }
}

- (void)showToastWithLiveDetectStatus:(NTESLDStatus)status {
    NSString *msg = @"";
    NSString *token;
    if ([self.params isKindOfClass:[NSDictionary class]]) {
        token = [self.params objectForKey:@"token"];
    }
    switch (status) {
        case NTESLDCheckPass:
            if ([NTESRNLiveDetectView sharedInstance].onResultChange) {
              [NTESRNLiveDetectView sharedInstance].onResultChange(@{
                    @"message": @"人脸识别检测通过",
                    @"token": token,
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                 
            });
            break;
        case NTESLDCheckNotPass:
            msg = @"人脸识别检测未通过";
            if ([NTESRNLiveDetectView sharedInstance].onResultChange) {
              [NTESRNLiveDetectView sharedInstance].onResultChange(@{
                    @"message": msg,
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
             
            });
            break;
        case NTESLDOperationTimeout:
            msg = @"操作超时，用户未在规定时间内完成动作";
            if ([NTESRNLiveDetectView sharedInstance].onResultChange) {
              [NTESRNLiveDetectView sharedInstance].onResultChange(@{
                    @"message": msg,
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                    
            });
            break;
        case NTESLDGetConfTimeout:
            msg = @"活体检测获取配置信息超时";
            if ([NTESRNLiveDetectView sharedInstance].onResultChange) {
              [NTESRNLiveDetectView sharedInstance].onResultChange(@{
                    @"message": msg,
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                     
            });
            break;
        case NTESLDOnlineCheckTimeout:
            msg = @"云端检测结果请求超时";
            if ([NTESRNLiveDetectView sharedInstance].onResultChange) {
              [NTESRNLiveDetectView sharedInstance].onResultChange(@{
                    @"message": msg,
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                       
            });
            break;
        case NTESLDOnlineUploadFailure:
            msg = @"云端检测上传图片失败";
            if ([NTESRNLiveDetectView sharedInstance].onResultChange) {
              [NTESRNLiveDetectView sharedInstance].onResultChange(@{
                    @"message": msg,
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                        
            });
            break;
        case NTESLDNonGateway:
            msg = @"网络未连接";
            if ([NTESRNLiveDetectView sharedInstance].onResultChange) {
              [NTESRNLiveDetectView sharedInstance].onResultChange(@{
                    @"message": msg,
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                        
            });
            break;
        case NTESLDSDKError:
//            vc.message = @"SDK内部错误";
//            vc.loginType = NTESQuickLoginTypeFailure;
//            [self.navigationController pushViewController:vc animated:YES];
            break;
        case NTESLDCameraNotAvailable:
            msg = @"App未获取相机权限";
            if ([NTESRNLiveDetectView sharedInstance].onResultChange) {
              [NTESRNLiveDetectView sharedInstance].onResultChange(@{
                    @"message": msg,
                });
            }
            dispatch_async(dispatch_get_main_queue(), ^(){
                        
            });
            break;
        default:
//            vc.message = @"未知错误";
//            vc.loginType = NTESQuickLoginTypeFailure;
//            [self.navigationController pushViewController:vc animated:YES];
            break;
    }
}



@end
