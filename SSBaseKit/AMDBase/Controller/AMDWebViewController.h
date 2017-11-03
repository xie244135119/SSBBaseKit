//
//  AMDWebViewController.h
//  AppMicroDistribution
//  web控制器<不再允许直接引用>
//  Created by SunSet on 15-6-19.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDRootViewController.h"


@interface AMDWebViewController : AMDRootViewController

// 使用平台签名的请求地址
@property(nonatomic, copy) NSString *requestWithSignURL;
// 跳转类型 1:正常压栈(默认) 2：模态显示 0默认一级页面
@property(nonatomic) NSInteger showType;
// 优先设置的标题
@property(nonatomic, copy) NSString *priorityTitle;


@end





