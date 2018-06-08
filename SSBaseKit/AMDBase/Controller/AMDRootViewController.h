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
// 默认为YES
@property(nonatomic) BOOL supportBack;

/*
 * 控制器实例化 (尽量不要调用)
 * @param1 标题
 */
- (instancetype)initWithTitle:(NSString *)title NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithTitle:(NSString *)title
               titileViewShow:(BOOL)titleViewShow NS_DESIGNATED_INITIALIZER;


#pragma mark - 进去页面方式
/**
 *  进入页面方式 模态还是压栈
 */
- (AMDControllerShowType)controllerShowType;

/**
 进入页面是否需要动画 默认为YES

 @return 是否需要动画
 */
- (BOOL)controllerShowAnimate;


@end








