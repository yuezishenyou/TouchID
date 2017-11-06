//
//  TouchIDHelper.m
//  ydx_Finger
//
//  Created by maoziyue on 2017/11/6.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "TouchIDHelper.h"
#import <LocalAuthentication/LocalAuthentication.h>


@implementation TouchIDHelper




+ (void)postGetTouchID:(completion)completion
{
    
    LAContext *myContext = [[LAContext alloc] init];
    
    // 这个属性是设置指纹输入失败之后的弹出框的选项
    myContext.localizedFallbackTitle = @"忘记密码";
    
    NSError *authError = nil;
    
    NSString *myLocalizedReasonString = @"请按住Home键完成验证";
    
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            if(success)
            {
                NSLog(@"指纹认证成功");
                if (completion) {
                    completion(0,0);
                }
                
            }
            else
            {
                NSLog(@"指纹认证失败:%d",error.code);
                
                if (completion) {
                    completion(1,error.code);
                }
                
                switch (error.code)
                {
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"授权失败");
                    }
                        break;
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                        
                    }
                        break;
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        
                    }
                        break;
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"取消授权，如其他应用切入，用户自主");
                    }
                        break;
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"设备系统未设置密码");
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:
                    {
                        NSLog(@"设备未设置Touch ID");
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:
                    {
                        NSLog(@"用户未录入指纹");
                    }
                        break;
                        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
                    case LAErrorTouchIDLockout:
                    {
                        NSLog(@"Touch ID被锁，需要用户输入密码解锁");
                    }
                        break;
                    case LAErrorAppCancel:
                    {
                        NSLog(@"用户不能控制情况下APP被挂起");
                    }
                        break;
                    case LAErrorInvalidContext:
                    {
                        NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                    }
                        break;
#else
#endif
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"其他情况，切换主线程处理");
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        NSLog(@"设备不支持指纹");
        if (completion) {
            completion(1,897);
        }
        switch (authError.code)
        {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"Authentication could not start, because Touch ID has no enrolled fingers");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"Authentication could not start, because passcode is not set on the device");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
    }
}






























@end
