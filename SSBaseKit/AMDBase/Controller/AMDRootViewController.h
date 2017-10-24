//
//  AMDRootViewController.h
//  AppMicroDistribution
//  总父类
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMDRootProtocol.h"
#import "AMDRootNavgationBar.h"
#import "AMDBackControl.h"


typedef NS_ENUM(NSUInteger, AMDControllerShowType) {
    AMDControllerShowTypePresent,                 //模态显示
    AMDControllerShowTypePush,                      //导航显示
};


@interface AMDRootViewController : UIViewController <AMDRootProtocol>


// 内容视图
@property(nonatomic, readonly) UIView *contentView;
// 内部视图
@property(nonatomic, readonly) AMDRootNavgationBar *titleView;

// 支持显示后退按钮
@property(nonatomic, weak) AMDBackControl *backItem;
@property(nonatomic) BOOL supportBackBt NS_DEPRECATED_IOS(2_0, 7_0, "已废弃无用 后续不需要再自行处理后退按钮事件") ;
@property(nonatomic) BOOL supportBack;
// 设置消息提醒数量(类似微信后退按钮数量处理)
@property(nonatomic) NSInteger messageCount;


/*
 * 控制器实例化
 * @param1 标题
 */
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title
               titileViewShow:(BOOL)titleViewShow;
/*
 * @param1 导航栏是否展示 @param2 标题  @param3 tabbar栏高度是否展示
 */
- (instancetype)initWithTitle:(NSString *)title
               titileViewShow:(BOOL)titleViewShow
                   tabBarShow:(BOOL)tabbarshow;

/**
 *  进入页面方式 模态还是压栈
 */
- (AMDControllerShowType)controllerShowType;



@end








