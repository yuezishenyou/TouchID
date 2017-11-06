//
//  HHLoginController.m
//  ydx_Finger
//
//  Created by maoziyue on 2017/11/6.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "HHLoginController.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import "HHAlertView.h"
#import "TouchIDHelper.h"


#define kIsSuort  @""


typedef void(^TransLoginStateBlock)(void);

@interface HHLoginController ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPass;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (copy, nonatomic) TransLoginStateBlock transLoginStateBlock;




@end

@implementation HHLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"login";
    
    self.textFieldPhone.text = @"18217726501";
    self.textFieldPass.text  = @"maoziyue";
    

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *authentication =[ud objectForKey:@"authentication"];
    BOOL isOpen = [ud boolForKey:@"isOpen"];
    
    if (isOpen && authentication.length != 0) {
         [self touchLogin];
    }
    
}




- (IBAction)loginBtnAction:(id)sender
{
    NSLog(@"----登录-----");
   
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *authentication =[ud objectForKey:@"authentication"];
    BOOL isOpen = [ud boolForKey:@"isOpen"];
    
    
    if (!isOpen)
    {
        [self loginNomal];
    }
    else
    {
        if (authentication.length == 0)
        {
            [self loginNomal];
        }
        else
        {
            
        }
    }
}


- (void)loginNomal
{
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"----登录成功-----");
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        BOOL isOpen = [ud boolForKey:@"isOpen"];
        
        if (!isOpen)
        {//不开启指纹
            [weakSelf alert:@"登录成功" cancel:nil sure:@"确定" block:^(NSInteger index){
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
        }
        else
        {//开启指纹
            
            if (![self isSuportTouchID])
            {//不支持TouchID
                [weakSelf alert:@"登录成功" cancel:nil sure:@"确定" block:^(NSInteger index){
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
            else
            {//支持
                NSString *msg = @"登录成功,您是否要启用TouchID?";
                [self alert:msg cancel:@"取消" sure:@"启动" block:^(NSInteger index) {
                    if (index == 0){
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }else if (index == 1){
                        [weakSelf loadAuthentication];
                    }
                }];
            }
        }
    });

}



- (BOOL)isSuportTouchID
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        return YES;
    }
    return NO;
}

//指纹认证
- (void)loadAuthentication
{
    __weak typeof(self) weakSelf = self;
    
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
                
                //我需要把用户名密码，或者自己整个东西，本机的东西，加密送到服务器获得token
                //有结果后，
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setBool:YES forKey:@"isLogin"];
                [ud setObject:@"authentication" forKey:@"authentication"];
               
                [weakSelf alert:@"认证成功" cancel:nil sure:@"确定" block:^(NSInteger index){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                
            }
            else
            {
                NSLog(@"指纹认证失败，%@",error.description);

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




//指纹登录
- (void)touchLogin
{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"loginState"];
    
    TouchIDHelper *helper = [TouchIDHelper manager];
    helper.isLoginState = YES;
    
    __weak typeof(self ) weakSelf = self;
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"忘记密码";
    NSString *myLocalizedReasonString = @"请按住Home键完成登录";
    NSError *error = nil;
    // 判断设备是否支持指纹识别功能
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        // 支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success)
            {
                NSLog(@"----指纹登录成功------");
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setBool:YES forKey:@"isLogin"];
                [ud setObject:@"authentication" forKey:@"authentication"];
                
                [weakSelf alert:@"指纹登录成功" cancel:nil sure:@"确定" block:^(NSInteger index){
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
            else
            {
                 NSLog(@"----指纹登录失败------");
            }
            
        }];
    }
    else
    {
        NSLog(@"---不支持指纹验证----");
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"startAutoLoginState"];
    }
    
}

















- (void)alert:(NSString *)message cancel:(NSString *)cancel sure:(NSString *)sure block:(void(^)(NSInteger index))block
{
    [HHAlertView  alertWithController:self
                                title:@"提示"
                              message:message
                               cancel:cancel
                                 sure:sure
                                block:block
     ];
}

























@end
