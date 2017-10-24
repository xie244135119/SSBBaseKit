//
//  AMDQrcodeController.h
//  AppMicroDistribution
//  二维码扫描相关
//  Created by SunSet on 15-6-5.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//


#import "AMDRootViewController.h"
#import "AMDControllerTransitionDelegate.h"
//
typedef void(^AMDQrcodeScanAction)(NSString *codeStr, NSError *error);

@interface AMDQrcodeController : AMDRootViewController


//委托实例---返回的值为扫描出来的字符串
@property(nonatomic, weak) id<AMDControllerTransitionDelegate> delegate;

//扫描结果之后的行为
@property(nonatomic, copy) AMDQrcodeScanAction scanAction;


@end
