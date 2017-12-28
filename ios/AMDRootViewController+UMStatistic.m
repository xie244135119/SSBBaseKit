//
//  AMDRootViewController+UMStatistic.m
//  AppMicroDistribution
//
//  Created by SunSet on 2017/6/20.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "AMDRootViewController+UMStatistic.h"
#import <objc/runtime.h>
//#import <SSBasePlugin/SSUMMobService.h>
//#import "LoginInfoStorage.h"

@implementation AMDRootViewController (UMStatistic)


// 改变两者之间实现
+ (void)exchangeSel:(SEL)originSel senderSel:(SEL)senderSel
{
    Method orignMethod = class_getInstanceMethod([self class], originSel);
    Method senderMethod = class_getInstanceMethod([self class], senderSel);
    method_exchangeImplementations(orignMethod, senderMethod);
}

+ (void)load
{
    [self exchangeSel:@selector(viewWillAppear:) senderSel:@selector(amd_viewWillAppear:)];
    [self exchangeSel:@selector(viewWillDisappear:) senderSel:@selector(amd_viewWillDisappear:)];
    [self exchangeSel:@selector(viewDidLoad) senderSel:@selector(amd_viewDidLoad)];
    [self exchangeSel:@selector(preferredStatusBarStyle) senderSel:@selector(amd_preferredStatusBarStyle)];
}


// 用于友盟统计
- (void)amd_viewWillAppear:(BOOL)animate
{
    [self amd_viewWillAppear:animate];
    //
    self.navigationController.navigationBarHidden = YES;
    
    // uMeng统计
//    [SSUMMobService beginLogPageView:[[self class] description]];
    
    // 设置后退按钮颜色
    if (self.supportBack) {
//        self.backItem.imgStrokeColor = [self preferredStatusBarStyle]==UIStatusBarStyleDefault?[UIColor colorWithRed:(CGFloat)75/255 green:(CGFloat)75/255 blue:(CGFloat)75/255 alpha:1]:[UIColor whiteColor];
    }
}

- (void)amd_viewWillDisappear:(BOOL)animate
{
    [self amd_viewWillDisappear:animate];
    
//    [SSUMMobService endLogPageView:[[self class] description]];
}


- (void)amd_viewDidLoad
{
    [self amd_viewDidLoad];
    
    // 设置导航颜色
    if (self.titleView) {
//        self.titleView.naviationBarColor = [UIColor redColor];
        if (self.titleView.title.length == 0) {
            self.titleView.title = @" ";
        }
//        self.titleView.titleLabel.textColor = [UIColor whiteColor];
    }
}


//- (UIStatusBarStyle)amd_preferredStatusBarStyle
//{
//    return [LoginInfoStorage sharedStorage].statusBarStyle;
//}



@end
