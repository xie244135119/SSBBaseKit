//
//  AMDBackControl.h
//  AppMicroDistribution
//
//  Created by SunSet on 16/10/26.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AMDBackControl : UIControl

/*
 * 设置默认后退按钮颜色
 [[UINavigationBar appearance]setTintColor:[UIColorwhiteColor]]
 */


// 消息提醒标签
@property(nonatomic, weak) UILabel *mesRemindLabel;
// 线条颜色
@property(nonatomic, strong) UIColor *imgStrokeColor;


@end

















