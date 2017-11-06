//
//  TouchIDHelper.h
//  ydx_Finger
//
//  Created by maoziyue on 2017/11/6.
//  Copyright © 2017年 maoziyue. All rights reserved.
//



/**
 * 几个状态
 0.是不是支持TouchID
 1.是不是开启TouchID
 2.开启后有没有验证
 2.有没有登录
 */


#import <Foundation/Foundation.h>


// code = 0 成功
// code = 1 错误，error = 897 不支持
typedef void(^completion)(NSInteger code, NSInteger error);


@interface TouchIDHelper : NSObject

@property (nonatomic, assign)BOOL isOpen;

@property (nonatomic, assign)BOOL isSupport;

@property (nonatomic, assign)BOOL isIdentity;

@property (nonatomic, assign)BOOL isLogin;



+ (void)postGetTouchID:(completion)completion;



@end
