//
//  ViewController.m
//  ydx_Finger
//
//  Created by maoziyue on 2017/11/6.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "ViewController.h"
#import "TouchIDHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [TouchIDHelper postGetTouchID:^(NSInteger code, NSInteger error) {
        
        if (code == 0) {
            NSLog(@"-----成功-----");
        }
        else
        {
            NSLog(@"-----code:%ld---error:%ld--",(long)code,(long)error);
        }
        
    }];
    
    
}







@end
