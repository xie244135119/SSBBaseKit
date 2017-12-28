//
//  AMDRootNavgationBar.h
//  AppMicroDistribution
//  根导航
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDRootNavgationBar : UIView

/*
 *  设置默认背景色
 设置NavigationBar背景颜色 和 文字默认颜色
 [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]]
 [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]
 */


// 左侧的views
@property(nonatomic,strong) NSArray *leftViews;
// 右侧的views
@property(nonatomic,strong) NSArray *rightViews;
// 背景色
@property(nonatomic,strong) UIImage *backgroundimage;
// 标题
@property(nonatomic,copy) NSString *title;
@property(nonatomic,weak) UILabel *titleLabel;
// 导航栏
@property(nonatomic,weak) UINavigationBar *naviationBar;
// 导航背景色
@property(nonatomic,strong) UIColor *naviationBarColor;


@end







