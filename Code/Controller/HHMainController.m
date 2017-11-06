//
//  HHMainController.m
//  ydx_Finger
//
//  Created by maoziyue on 2017/11/6.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "HHMainController.h"
#import "HHLoginController.h"
#import "HHAlertView.h"
#import "TouchIDHelper.h"

@interface HHMainController ()

@end

@implementation HHMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"main";
    
    [self initSubViews];
    
    

    
    
}

- (void)initSubViews
{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStyleDone target:self action:@selector(logout)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(20, 100, 100, 40);
    
    btn.backgroundColor = [UIColor redColor];
    
    [btn setTitle:@"login" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    
    
    
    
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    BOOL isOpen = [ud boolForKey:@"isOpen"];
    
    UISwitch *mSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(20, 300, 100, 40)];
    
    mSwitch.on = isOpen;
    
    [mSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:mSwitch];

}

- (void)switchAction:(UISwitch *)mSwitch
{
    BOOL isOpen = mSwitch.on;
    
    NSLog(@"----%u----",mSwitch.on);
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setBool:isOpen forKey:@"isOpen"];

}






- (void)btnAction
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    BOOL isLogin = [ud boolForKey:@"isLogin"];
    
    if (isLogin)
    {
        [HHAlertView alertWithController:self title:@"提示" message:@"已经登录了" cancel:nil sure:@"确定" block:nil];
    }
    else
    {
        HHLoginController *login = [[HHLoginController alloc]initWithNibName:@"HHLoginController" bundle:nil];
        
        [self.navigationController pushViewController:login animated:YES];
    }
    

}


- (void)logout
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setBool:NO forKey:@"isLogin"];
    
    [HHAlertView alertWithController:self title:@"提示" message:@"退出成功" cancel:nil sure:@"确定" block:nil];
}








@end
