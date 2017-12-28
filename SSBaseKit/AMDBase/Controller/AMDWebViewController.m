//
//  AMDWebViewController.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-6-19.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDWebViewController.h"
#import "AMDAnimationWebView.h"
#import "AMDButton.h"
#import "AMDCloseControl.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>

@interface AMDWebViewController() <AMDWebViewDelegate>
{
    AMDAnimationWebView *_currentAnimationView;              //动画视图
    __weak AMDCloseControl *_currentCloseBt;
}
@end

@implementation AMDWebViewController


- (void)dealloc
{
    if ([_currentAnimationView.wkWebView isKindOfClass:[WKWebView class]]) {
        [_currentAnimationView.wkWebView removeObserver:self forKeyPath:@"title"];
    }
    self.requestWithSignURL = nil;
    _currentAnimationView = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initContentView];
    [self initNavView];
}


#pragma mark - AMDRootProtocol
// 页面刷新
- (void)preReload
{
//    [_currentAnimationView.uiWebView reload];
    [_currentAnimationView.wkWebView reload];
}



#pragma mark - 视图加载
- (void)initContentView
{
    self.titleView.title = @"";
    //加载框
    AMDAnimationWebView *animationView = [[AMDAnimationWebView alloc]init];
    animationView.requestWithSignURL = _requestWithSignURL;
    animationView.delegate = self;
    animationView.controller = self;
    if (self.titleView) {
        [self.contentView insertSubview:animationView belowSubview:self.titleView];
    }
    else {
        [self.contentView addSubview:animationView];
    }
    
    _currentAnimationView = animationView;
    [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    // 建立监听
    [self initObserverForWkTitle];
    
    // 有优先级标题
    if (_priorityTitle.length > 0) {
        self.titleView.title = _priorityTitle;
    }
    else {
        // 获取html标题
        __weak typeof(self) weakself = self;
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
            animationView.finishLoadAction_WK = ^(WKWebView *webView){
                weakself.titleView.title = webView.title;
            };
        }
    }
}

// 加载导航
- (void)initNavView
{
    // 压栈
    if (self.supportBack) {
#ifdef DEBUG
        // 更多按钮--仅供调试使用
        AMDButton *morebt = [[AMDButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40-5, 2, 40, 40)];
        morebt.imageView.frame = CGRectMake(8, 8, 24, 24);
        [morebt setImage:SSImageFromName(@"topicinfo_more.png") forState:UIControlStateNormal];
        [morebt setImage:SSImageFromName(@"topicinfo_more_select.png") forState:UIControlStateHighlighted];
        [morebt addTarget:self action:@selector(clickMoreAction:) forControlEvents:UIControlEventTouchUpInside];
        morebt.tag = 4;
        self.titleView.rightViews = @[morebt];
#endif
        return;
    }
    
    // 模态显示
    if (_showType == 2) {
        // 右侧关闭按钮
        AMDCloseControl *closebt = [[AMDCloseControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35-10, 0, 35, 44) lineColor:self.backItem.imgStrokeColor];
        closebt.tag = 2;
        [closebt addTarget:self action:@selector(clickBackAction:) forControlEvents:UIControlEventTouchUpInside];
        self.titleView.leftViews = @[closebt];
        _currentCloseBt = closebt;
        return;
    }
    
    // 处于一级页面的时候
    _currentAnimationView.delegate = self;
}

// 左侧添加关闭按钮--用于关闭当前页面
- (void)initCloseBt
{
    // 8.0之后的支持新的后退机制
    if ([UIDevice currentDevice].systemVersion.doubleValue < 8.0) {
        return;
    }
    
//    if (self.showType.intValue == 1)
//    {   //非模态情况下展示关闭按钮
        if (_currentCloseBt == nil) {
            AMDCloseControl *closebt = [[AMDCloseControl alloc]initWithFrame:CGRectMake(35, 0, 35, 44) lineColor:self.backItem.imgStrokeColor];
            closebt.tag = 1;
            [closebt addTarget:self action:@selector(clickBackAction:) forControlEvents:UIControlEventTouchUpInside];
            self.titleView.leftViews = @[closebt];
            _currentCloseBt = closebt;
            
            // 改变后退按钮的位置
            CGRect backitemframe = self.backItem.frame;
            backitemframe.size.width = closebt.frame.origin.x;
            self.backItem.frame = backitemframe;
        }
//    }
}



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
//    if ([_currentAnimationView.uiWebView canGoBack]) {
//        [_currentAnimationView.uiWebView goBack];
//        return ;
//    }
    
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
    NSString *urlstr = _currentAnimationView.wkWebView.URL.description?_currentAnimationView.wkWebView.URL.description:@"";
    //(_currentAnimationView.uiWebView.request.URL.description?_currentAnimationView.uiWebView.request.URL.description:@"");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"临时测试使用" message:urlstr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消"
                             style:UIAlertActionStyleDefault
                           handler:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"复制剪切板"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * _Nonnull action) {
                               [[UIPasteboard generalPasteboard] setString:urlstr];
                           }];
    [alert addAction:cancelaction];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}




// 添加关闭按钮
#pragma mark - AMDWebViewDelegate
//#else
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_requestWithSignURL && (self.supportBack)) {
        if (![_requestWithSignURL isEqualToString:webView.request.URL.description]) {
//            if (navigationType == UIWebViewNavigationTypeOther) {
                [self initCloseBt];
//            }
        }
    }
}

// 跳转二级页面
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 如果不是一级页面 自动后退
    if(self.supportBack) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    // 如果跳转的资源文件--默认禁掉
    if([navigationAction.request.URL.path hasSuffix:@".txt"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    // 当前页面需要跳转新页面
    if ([navigationAction.request.URL.description hasPrefix:@"http"]) {
        // 跳转二级页面
        [self performSelector:@selector(_pushWebViewWithUrl:) withObject:navigationAction.request.URL.description afterDelay:0.1];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - 检测标题 发生变化 触发后退按钮
- (void)initObserverForWkTitle
{
    if ([_currentAnimationView.wkWebView isKindOfClass:[WKWebView class]]) {
        [_currentAnimationView.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
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



#pragma mark - private api
// 跳转控制器
- (void)_pushWebViewWithUrl:(NSString *)aUrl
{
    AMDWebViewController *webVc = [[AMDWebViewController alloc]init];
    webVc.requestWithSignURL = aUrl;
    webVc.supportBack = YES;
    [self.navigationController pushViewController:webVc animated:YES];
}



@end







