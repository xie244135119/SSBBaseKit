//
//  ViewController.m
//  ios
//
//  Created by SunSet on 2017/6/6.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "ViewController.h"
#import "SSGlobalVar.h"
#import "AMDSelectItemView.h"
#import "AMDWebViewController.h"
#import "AMDLabelFieldView.h"
#import "AMDBackControl.h"
#import "AMDButton.h"
#import <sys/utsname.h>
#import "AMDTabbarController.h"
#import "TestController.h"


@interface ViewController ()
{
    AMDButton *_currentBt;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.supportBackBt = YES;
//    self.backItem.layer.borderWidth = 1;
    self.backItem.imgStrokeColor = SSColorWithRGB(75, 75, 75, 1);
//    [self initContentView];
    
    
    self.titleView.title = @"阿萨帝发送到发送到发送方的";
//    [self testLineItemView];
//    [self performSelector:@selector(initContentView) withObject:nil afterDelay:0.5];
//    [self testTextFieldView];
//    [self testBackView];
    //
//    [self testButton];
    
    [self performSelector:@selector(testTabBar) withObject:nil afterDelay:0.1];
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

- (void)testLineItemView
{
    AMDSelectItemView *itemView = [[AMDSelectItemView alloc]initWithFrame:CGRectMake(100, 100, 24, 24)];
    itemView.strokeColor = [UIColor redColor];
    [self.view addSubview:itemView];
}


- (void)testTextFieldView
{
    AMDLabelFieldView *field = [[AMDLabelFieldView alloc]initWithFrame:CGRectMake(0, 100, 300, 50)];
    field.layer.borderWidth = 1;
    field.textField.maxInputChars = 5;
    field.titleLabel.text = @"测试";
    [self.view addSubview:field];
}


- (void)testBackView
{
    AMDBackControl *backView = [[AMDBackControl alloc]initWithFrame:CGRectMake(80, 100, 100, 44)];
    backView.backgroundColor = [UIColor blackColor];
    backView.imgStrokeColor = [UIColor whiteColor];
    [self.view addSubview:backView];
}

// 测试按钮
- (void)testButton
{
    AMDButton *bt = [[AMDButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    bt.layer.borderWidth = 1;
    bt.titleLabel.textColor = [UIColor redColor];
    bt.imageView.image = [UIImage imageNamed:@"SSBaseKit/topicinfo_more.png"];
    bt.imageView.frame = CGRectMake(30, 30, 40, 40);
    bt.imageView.layer.borderWidth = 1;
    bt.titleLabel.text = @"测试";
    [self.contentView addSubview:bt];
    _currentBt = bt ;
    //
    [bt supportRemindNumber];
    [bt setUnreadCount:3];
}


// 底部tabbar
- (void)testTabBar
{
    TestController *webVC = [[TestController alloc]initWithTitle:@"阿生的"];
    AMDRootViewController *webVC2 = [[AMDRootViewController alloc]initWithTitle:@"测试"];
     AMDRootViewController *webVC3 = [[AMDRootViewController alloc]initWithTitle:@"测试"];
     AMDRootViewController *webVC4 = [[AMDRootViewController alloc]initWithTitle:@"测试"];
    
    AMDTabbarController *tabbarVc = [[AMDTabbarController alloc]initWithItemsTitles:@[@"asdf",@"aswew",@"232",@"234asdfa"] itemImages:@[[UIImage imageNamed:@"SSBaseKit.bundle/topicinfo_more_select.png"], [UIImage imageNamed:@"SSBaseKit.bundle/topicinfo_more_select.png"],[UIImage imageNamed:@"SSBaseKit.bundle/topicinfo_more_select.png"],[UIImage imageNamed:@"SSBaseKit.bundle/topicinfo_more_select.png"]] itemSelctImages:@[[UIImage imageNamed:@"SSBaseKit.bundle/topicinfo_more_select.png"], [UIImage imageNamed:@"SSBaseKit.bundle/topicinfo_more_select.png"],[UIImage imageNamed:@"SSBaseKit.bundle/topicinfo_more_select.png"],[UIImage imageNamed:@"SSBaseKit.bundle/topicinfo_more_select.png"]]];
//    UITabBarController *tabbarVc = [[UITabBarController alloc]init];
    tabbarVc.viewControllers = @[webVC, webVC2,webVC3,webVC4];
    [self presentViewController:tabbarVc animated:YES completion:nil];
}




-(IBAction)clickTest:(id)sender
{
    NSInteger count = random()*100;
    [_currentBt setUnreadCount:count];
}


@end












