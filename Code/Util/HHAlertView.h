//
//  HHAlertView.h
//  ydx_Finger
//
//  Created by maoziyue on 2017/11/6.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^selectedIndex)(NSInteger index);

@interface HHAlertView : NSObject

+ (instancetype)alertWithController:(UIViewController *)vc title:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel sure:(NSString *)sure block:(selectedIndex)block;


@end
