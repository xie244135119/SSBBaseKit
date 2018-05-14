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
#import "AYEActionSheetView.h"
#import "AMDQrcodeController.h"
#import "AMDLabelShowView.h"
#import "SSLinkageView.h"
#import "SSClassifyView.h"
#import <Masonry/Masonry.h>

@interface ViewController ()<UINavigationControllerDelegate,
                                UIGestureRecognizerDelegate,
                                SSLinkageViewDelegate>
{
    AMDButton *_currentBt;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    // 文本颜色
    UIColor *backitemcolor = [self preferredStatusBarStyle]==UIStatusBarStyleDefault?[UIColor colorWithRed:(CGFloat)75/255 green:(CGFloat)75/255 blue:(CGFloat)75/255 alpha:1]:[UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:backitemcolor];
    // 导航默认颜色 和 文本颜色
//    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    //
    
//    self.supportBackBt = YES;
//    self.backItem.layer.borderWidth = 1;
//    self.backItem.imgStrokeColor = SSColorWithRGB(75, 75, 75, 1);
//    [self initContentView];
    [self testLinkPageView];
//    self.contentView.layer.borderWidth = 1;
//    self.view.layer.borderWidth = 1;
//    self.view.layer.borderColor = [UIColor redColor].CGColor;
//    if (@available(iOS 11.0, *)) {
//        self.view.safeAreaLayoutGuide.owningView.layer.borderWidth = 1;
//    } else {
//        // Fallback on earlier versions
//    }
//    self.view.safeAreaLayoutGuide.owningView.layer.borderColor = [UIColor redColor].CGColor;
    
//    self.titleView.title = @"阿萨帝发送到发送到发送方的";
//    [self testLineItemView];
//    [self performSelector:@selector(initContentView) withObject:nil afterDelay:0.5];
//    [self testTextFieldView];
//    [self testBackView];
    //
//    [self testButton];

//    [self performSelector:@selector(testTabBar) withObject:nil afterDelay:0.1];
    //
//    [self performSelector:@selector(testActionSheet) withObject:nil afterDelay:0.1];
//    [self performSelector:@selector(testWebView) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    UIEdgeInsets inset = self.view.safeAreaInsets;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UIEdgeInsets inset = self.view.safeAreaInsets;
}


//- (void)viewSafeAreaInsetsDidChange
//{
//    //
//    [super viewSafeAreaInsetsDidChange];
//
//}



// 视图加载
- (void)initContentView
{
    SSClassifyView *view = [[SSClassifyView alloc]init];
    view.delegate = self;
    view.dataSource = self;
    view.rowSpace = 10;
    view.imageSize = CGSizeMake(80, 80);
    view.rowHeight = 100;
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(400);
        make.height.offset(200);
    }];
    [view prepareForLoad];
    view.layer.borderWidth = 1;
    
    return;
    //
    AMDLabelShowView *labelshow = [[AMDLabelShowView alloc]initWithFrame:CGRectMake(0, 100, 320, 50)];
    labelshow.layer.borderWidth = 1;
    labelshow.titleLabel.text = @"用户名";
    labelshow.contentLabel.text = @"18721025826";
    [self.view addSubview:labelshow];
    AYEActionSheetView *sheetView = [[AYEActionSheetView alloc]initWithdelegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"测试", nil];
    [sheetView showInView:self.view];
    
//    AMDRootViewController *webVC = [[AMDRootViewController alloc]initWithTitle:@"阿萨帝发送到发送到发的啥发送的阿萨德发生的"];
//    [self presentViewController:webVC animated:YES completion:nil];
////
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
//    [self.contentView addSubview:bt];
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

// 测试弹出窗口
- (void)testActionSheet
{
    AYEActionSheetView *sheetView = [[AYEActionSheetView alloc]initWithdelegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"测试1",@"测试2",@"差盛大发送到发送到", nil];
    [sheetView showInView:self.view];
}


- (IBAction)testWebView
{
    AMDWebViewController *webVc = [[AMDWebViewController alloc]init];
//    webVc.requestWithSignURL = @"http://m.xuanwonainiu.com/c?pageId=179&nav=0&p=14299&refresh=1";
    webVc.requestWithSignURL = @"https://baidu.com/";
//    webVc.requestWithSignURL = @"http://m.xuanwonainiu.com/sp-dlsearch?p=14299&scale=50&searchText=&splitWord=true";
//    webVc.showType = 0;
    [self.navigationController pushViewController:webVc animated:YES];
}

// 测试轮播视图
- (void)testLinkPageView
{
    SSLinkageView *linkPageView = [[SSLinkageView alloc]initWithFrame:CGRectMake(0, 0, 300, 200) imageUrls:@[@"http://wdwd-prod.wdwdcdn.com/5ad81142d0d91.jpg", @"http://wdwd-prod.wdwdcdn.com/5ad8115ac02c4.jpg"]];
    [self.view addSubview:linkPageView];
    linkPageView.layer.borderWidth = 1;
    linkPageView.delegate = self;
}


-(IBAction)clickTest:(id)sender
{
    [self _testScan];
    return;
    
    [self testActionSheet];
    return;
//    NSInteger count = random()*100;
//    [_currentBt setUnreadCount:count];
    [self testTabBar];
}


#pragma mark - 扫描
// 扫描二维码
- (void)_testScan
{
    AMDQrcodeController *codeVc = [[AMDQrcodeController alloc]init];
//    codeVc.
    [self.navigationController pushViewController:codeVc animated:YES];
}



#pragma mark -
- (void)AYEActionSheetView:(AYEActionSheetView *)sheetView DidTapWithTitle:(NSString *)title
{
    NSLog(@" 选中了某一个标题  %@",title);
}

- (void)AYEActionSheetView:(AYEActionSheetView *)sheetView DidTapWithIndex:(NSInteger)index
{
    NSLog(@" 选中了某一个index:%i ",index);
}

- (void)AYEActionSheetView:(AYEActionSheetView *)sheetView willDismissWithIndex:(NSInteger)index
{
    NSLog(@" 取消选中了某一个index:%i ",index);
}



#pragma mark -
//
//- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                            animationControllerForOperation:(UINavigationControllerOperation)operation
//                                                         fromViewController:(UIViewController *)fromVC
//                                                           toViewController:(UIViewController *)toVC
//{
//    if ([toVC isKindOfClass:[AMDRootViewController class]]) {
//        AMDRootViewController *vc = (AMDRootViewController *)toVC;
//        vc.supportBack = YES;
//    }
//    return nil;
//}



#pragma mark - UIGestureRecognizerDelegate 滑动后退
//
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}


#pragma mark -
- (NSArray<NSString *> *)classifyTitles{
    return @[@"奥术大师多",@"阿斯顿发送到",@"阿斯顿发送到2"];
}

/**
 @return 一组分类图片地址
 */
- (NSArray<NSURL *> *)classifyImageUrls{
    return @[@"",@"",@""];
}

- (void)classiftView:(SSClassifyView *)view didSelectAtIndex:(NSInteger)index{
    NSLog(@"index = %ld",(long)index);
}

#pragma mark - SSLinkageViewDelegate
//
- (void)linkPageView:(SSLinkageView *)pageView
    didScrollToImage:(UIView *)imageView
             atIndex:(NSInteger)index
{
    //
    UIView *senderView = [imageView viewWithTag:1000];
    if (senderView == nil) {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 200, 50)];
        v.tag = 1000;
        [imageView addSubview:senderView];
        v.layer.borderWidth = 1;

        // label
        UILabel *senderlb = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
        senderlb.text = @"阿萨撒旦法师打发";
        [v addSubview:senderlb];
    }
}





@end














