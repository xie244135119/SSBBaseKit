//
//  AMDWebViewController.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-6-19.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDWebViewController.h"
#import "AMDAnimationWebView.h"
//#import "AMDTool.h"
#import "AMDButton.h"
#import "SSGlobalVar.h"
//#import "AMDCommonClass.h"
//#import "YLJsBridgeSDK.h"

@interface AMDWebViewController() <AMDWebViewDelegate>
{
    AMDAnimationWebView *_currentAnimationView;              //动画视图
    __weak AMDButton *_currentCloseBt;
}
@end

@implementation AMDWebViewController

//+ (void)load
//{
//    [AMDRouter registerURLPattern:AMDWebViewPageURL withClass:[self class] withDescription:@"通用web页面"];
//}

- (void)dealloc
{
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        [_currentAnimationView.wkWebView removeObserver:self forKeyPath:@"title"];
    }
    self.requestWithSignURL = nil;
    _currentAnimationView = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavView];
    
    [self performSelectorOnMainThread:@selector(initContentView) withObject:nil waitUntilDone:NO];
}


- (instancetype)initWithTitle:(NSString *)title
{
    return [super initWithTitle:title];
}

- (instancetype)initWithTitle:(NSString *)title titileViewShow:(BOOL)titleViewShow tabBarShow:(BOOL)tabbarshow
{
    return nil;
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBarHidden = NO;
//}
//
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
////    self.titleView.hidden = NO;
//}


#pragma mark - AMDRootProtocol
// 页面刷新
- (void)preReload
{
    [_currentAnimationView.wkWebView reload];
    [_currentAnimationView.wkWebView reload];
}



#pragma mark - 视图加载
- (void)initContentView
{
    self.titleView.title = @"";
//    self.titleView.hidden = YES;
//    self.contentView.amd_y = 0;
    //加载框
    AMDAnimationWebView *animationView = [[AMDAnimationWebView alloc]initWithFrame:self.contentView.bounds];
    animationView.requestWithSignURL = _requestWithSignURL;
    animationView.delegate = self;
//    animationView.bridgeSDK.operationController = self;
    [self.contentView insertSubview:animationView belowSubview:self.titleView];
//    [self.contentView addSubview:animationView];
    _currentAnimationView = animationView;
    
    __weak typeof(self) weakself = self;
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        // 建立对title的监听
        [self initObserverForWkTitle];
        animationView.finishLoadAction_WK = ^(WKWebView *webView){
            weakself.titleView.title = webView.title;
        };
    }
    else {
        animationView.finishLoadAction_UI = ^(UIWebView *webView){
            // 题目的标题由document的title提供
            weakself.titleView.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        };
    }
}

// 加载导航
- (void)initNavView
{
    switch (_showType.intValue) {
//        case 1:         //压栈
//            self.supportBackBt = YES;
//            break;
        case 2:         //模态显示的关闭按钮
        {
            // 右侧关闭按钮
            AMDButton *closebt = [[AMDButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35-10, 0, 35, 44)];
            closebt.titleLabel.text = @"关闭";
            closebt.titleLabel.textColor = ColorWithRGB(51, 51, 51, 1);
            closebt.titleLabel.font = FontWithName(@"", 16);
            //        closebt.layer.borderWidth = 1;
            closebt.tag = 2;
            [closebt addTarget:self action:@selector(clickBackAction:) forControlEvents:UIControlEventTouchUpInside];
            self.titleView.leftViews = @[closebt];
            _currentCloseBt = closebt;
        }
            break;
        default:
        {
            self.supportBackBt = YES;
            
#ifdef DEBUG
            // 更多按钮--仅供调试使用
            AMDButton *morebt = [[AMDButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40-5, 2, 40, 40)];
            morebt.imageView.frame = CGRectMake(8, 8, 24, 24);
            [morebt setImage:imageFromBundleName(@"DynamicMoudle.bundle", @"topicinfo_more.png") forState:UIControlStateNormal];
            [morebt setImage:imageFromBundleName(@"DynamicMoudle.bundle", @"topicinfo_more_select.png") forState:UIControlStateHighlighted];
            [morebt addTarget:self action:@selector(clickMoreAction:) forControlEvents:UIControlEventTouchUpInside];
            morebt.tag = 4;
            self.titleView.rightViews = @[morebt];
#endif
        }
            break;
    }
}

// 左侧添加关闭按钮--用于关闭当前页面
- (void)initCloseBt
{
    // 8.0之后的支持新的后退机制
    if ([UIDevice currentDevice].systemVersion.doubleValue < 8.0) {
        return;
    }
    
    if (self.showType.intValue != 2)
    {   //非模态情况下展示关闭按钮
        if (_currentCloseBt == nil) {
            AMDButton *closebt = [[AMDButton alloc]initWithFrame:CGRectMake(25, 0, 35, 44)];
            closebt.titleLabel.text = @"关闭";
            closebt.tag = 1;
            closebt.titleLabel.textColor = ColorWithRGB(51, 51, 51, 1);
            closebt.titleLabel.font = FontWithName(@"", 15);
            //        closebt.layer.borderWidth = 1;
            [closebt addTarget:self action:@selector(clickBackAction:) forControlEvents:UIControlEventTouchUpInside];
            self.titleView.leftViews = @[closebt];
            _currentCloseBt = closebt;
        }
    }
}

// 替换主机地址
//- (NSString *)convertUrl:(NSString *)urlstr
//{
//    NSMutableString *aurlstr = [urlstr mutableCopy];
//    // 替换主机地址
//    if ([urlstr rangeOfString:@"{DOMAIN}"].length > 0) {
//        NSString *domain = GetDefaults(AMDYLDomain);
//        [aurlstr stringByReplacingOccurrencesOfString:@"{DOMAIN}" withString:domain];
//    }
//    if ([urlstr rangeOfString:@""].length > 0) {
//        
//    }
//    return aurlstr;
//}


#pragma mark - 按钮事件
// override 后退按钮
- (void)ClickBt_Back:(UIControl *)sender
{
    // 先后退页面
    if ([_currentAnimationView.wkWebView canGoBack]) {
        [_currentAnimationView.wkWebView goBack];
        
        return ;
    }
    
    // 先后退页面
    if ([_currentAnimationView.uiWebView canGoBack]) {
        [_currentAnimationView.uiWebView goBack];
        return ;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBackAction:(AMDButton *)sender
{
    switch (sender.tag) {
        case 1:     // 左侧压栈 关闭按钮
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2:     // 右侧模态 关闭按钮
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}


// 点击更多按钮
- (void)clickMoreAction:(AMDButton *)sender
{
    //
    NSString *urlstr = _currentAnimationView.wkWebView.URL.description;
//    [[AMDCommonClass sharedAMDCommonClass] showAlertTitle:@"测试使用" Message:urlstr action:nil cancelBt:@"确定" otherButtonTitles:nil, nil];
    NSLog(@" 测试地址 ：%@ ",urlstr);
}



//#pragma mark - 点击手势
//// 点击手势
//- (void)tapGestureRec:(UITapGestureRecognizer *)tap
//{
//    NSString *urlstr = _currentAnimationView.wkWebView.URL.description;
//    [[AMDCommonClass sharedAMDCommonClass] showAlertTitle:@"测试使用" Message:urlstr action:nil cancelBt:@"确定" otherButtonTitles:nil, nil];
//}
//
//
//// 添加手势
//- (void)addGestureRecognizer
//{
//    UITapGestureRecognizer *tap = [UITapGestureRecognizer]
//}



// 添加关闭按钮
#pragma mark - AMDWebViewDelegate
//#ifdef __IPHONE_8_0

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//    if (_requestWithSignURL && self.supportBackBt) {
//        if (![_requestWithSignURL isEqualToString:webView.URL.description]) {
//            [self initCloseBt];
//        }
//    }
//}

//#else
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_requestWithSignURL && self.supportBackBt) {
        if (![_requestWithSignURL isEqualToString:webView.request.URL.description]) {
//            if (navigationType == UIWebViewNavigationTypeOther) {
                [self initCloseBt];
//            }
        }
    }
}

//#endif
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
//{
//    NSLog(@" 加载error %@ ",error);
//}


#pragma mark - 检测标题 发生变化 触发后退按钮
- (void)initObserverForWkTitle
{
    [_currentAnimationView.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"title"]) {
        // 当用户后退的时候
        if (_currentAnimationView.wkWebView.backForwardList.forwardList.count > 0) {
            // 如果后退数组中还存在页面 显示关闭按钮
//            if (_currentAnimationView.wkWebView.backForwardList.backList.count > 0) {
                [self initCloseBt];
//            }
        }
    }
}





@end














