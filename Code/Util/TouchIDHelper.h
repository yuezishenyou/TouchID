//
//  TouchIDHelper.h
//  ydx_Finger
//
//  Created by maoziyue on 2017/11/6.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchIDHelper : NSObject

@property (nonatomic, assign)BOOL isLoginState;

@property (nonatomic, assign)BOOL isUseTouchID;

+ (instancetype)manager;



@end
