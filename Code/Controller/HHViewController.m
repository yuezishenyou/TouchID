//
//  HHViewController.m
//  ydx_Finger
//
//  Created by maoziyue on 2017/11/6.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "HHViewController.h"
#import "TouchIDHelper.h"

@interface HHViewController ()

@end

@implementation HHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"vc";
    
    [TouchIDHelper postGetTouchID:^(NSInteger code, NSInteger error) {
        
        NSLog(@"---%@---",[NSThread currentThread]);
        
        if (code == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
    }];
    
    
    
}



@end
