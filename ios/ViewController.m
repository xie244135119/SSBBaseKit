//
//  ViewController.m
//  ios
//
//  Created by SunSet on 2017/6/6.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "ViewController.h"
//#import <SSBaseKit/SSBaseKit.h>
//#import "SSBaseKit.h"
//#import "SSBaseKit.h"
//#import "AYEActionSheetView.h"

#import "AMDWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initContentView];
    
    [self performSelector:@selector(initContentView) withObject:nil afterDelay:0.5];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 视图加载
- (void)initContentView
{
    //
//    AMDLabelShowView *labelshow = [[AMDLabelShowView alloc]initWithFrame:CGRectMake(0, 100, 320, 50)];
//    labelshow.layer.borderWidth = 1;
//    labelshow.titleLabel.text = @"用户名";
//    labelshow.contentLabel.text = @"18721025826";
//    [self.view addSubview:labelshow];
//    AYEActionSheetView *sheetView = [[AYEActionSheetView alloc]initWithdelegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"测试", nil];
//    [sheetView showInView:self.view];
    
    AMDRootViewController *webVC = [[AMDRootViewController alloc]initWithTitle:@"阿萨帝发送到发送到发的啥发送的阿萨德发生的"];
    [self presentViewController:webVC animated:YES completion:nil];
//    
}



@end












