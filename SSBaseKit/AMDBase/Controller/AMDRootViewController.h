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


#pragma mark - 一期支持
/*
 * 控制器实例化 (尽量不要调用)
 * @param1 标题
 */
- (instancetype)initWithTitileViewShow:(BOOL)titleViewShow;
- (instancetype)initWithTitle:(NSString *)title NS_DEPRECATED_IOS(2_0, 8_0);
- (instancetype)initWithTitle:(NSString *)title
                        titileViewShow:(BOOL)titleViewShow NS_DEPRECATED_IOS(2_0, 8_0, "use initWithtitileViewShow");
- (instancetype)initWithTitle:(NSString *)title
               titileViewShow:(BOOL)titleViewShow
                   tabBarShow:(BOOL)tabbar NS_DEPRECATED_IOS(2_0, 8_0) ;



#pragma mark - 二期改造
// 只用默认导航栏处理
- (instancetype)initWithDefault;




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







