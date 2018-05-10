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


/**
 一组左侧的views
 */
@property(nonatomic,strong) NSArray<UIView *> *leftViews;

/**
 一组右侧的views
 */
@property(nonatomic,strong) NSArray<UIView *> *rightViews;

/**
 导航背景色
 */
@property(nonatomic,strong) UIImage *backgroundimage;

/**
 导航标题
 */
@property(nonatomic,copy) NSString *title;

/**
 导航标题组件
 */
@property(nonatomic,weak) UILabel *titleLabel;

/**
 导航栏
 */
@property(nonatomic, readonly) UINavigationBar *naviationBar;

/**
 导航背景色
 */
@property(nonatomic,strong) UIColor *naviationBarColor;


@end







