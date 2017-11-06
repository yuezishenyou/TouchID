//
//  TouchIDHelper.m
//  ydx_Finger
//
//  Created by maoziyue on 2017/11/6.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import "TouchIDHelper.h"

@implementation TouchIDHelper

+ (instancetype)manager
{
    static TouchIDHelper *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_manager == nil) {
            _manager = [[TouchIDHelper alloc]init];
        }
    });
    return _manager;
}







@end
