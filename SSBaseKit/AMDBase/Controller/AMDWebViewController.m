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


- (instancetype)initWithTitle:(NSString *)title
{
    return [super initWithTitle:title];
}

- (instancetype)initWithTitle:(NSString *)title titileViewShow:(BOOL)titleViewShow tabBarShow:(BOOL)tabbarshow
{
    return nil;
}



#pragma mark - AMDRootProtocol
// 页面刷新
- (void)preReload
{
    [_currentAnimationView.uiWebView reload];
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
    [self.contentView insertSubview:animationView belowSubview:self.titleView];
    _currentAnimationView = animationView;
    [animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
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
        case 1:         //压栈
        {
            self.supportBackBt = YES;
            
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
        }
            break;
        case 2:         //模态显示的关闭按钮
        {
            // 右侧关闭按钮
            AMDCloseControl *closebt = [[AMDCloseControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35-10, 0, 35, 44)];
//            closebt.titleLabel.text = @"关闭";
//            closebt.titleLabel.textColor = SSColorWithRGB(51, 51, 51, 1);
//            closebt.titleLabel.font = SSFontWithName(@"", 16);
            //        closebt.layer.borderWidth = 1;
            closebt.tag = 2;
            [closebt addTarget:self action:@selector(clickBackAction:) forControlEvents:UIControlEventTouchUpInside];
            self.titleView.leftViews = @[closebt];
            _currentCloseBt = closebt;
        }
            break;
        default: {      //一级页面的时候 默认跳转二级页面
            _currentAnimationView.delegate = self;
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
    
    if (self.showType.intValue == 1)
    {   //非模态情况下展示关闭按钮
        if (_currentCloseBt == nil) {
            AMDCloseControl *closebt = [[AMDCloseControl alloc]initWithFrame:CGRectMake(40, 0, 35, 44)];
//            closebt.titleLabel.text = @"关闭";
            closebt.tag = 1;
//            closebt.titleLabel.textColor = SSColorWithRGB(51, 51, 51, 1);
//            closebt.titleLabel.font = SSFontWithName(@"", 15);
            //        closebt.layer.borderWidth = 1;
            [closebt addTarget:self action:@selector(clickBackAction:) forControlEvents:UIControlEventTouchUpInside];
            self.titleView.leftViews = @[closebt];
            _currentCloseBt = closebt;
            
            // 改变后退按钮的位置
            CGRect backitemframe = self.backItem.frame;
            backitemframe.size.width = closebt.frame.origin.x;
            self.backItem.frame = backitemframe;
        }
    }
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
    NSString *urlstr = _currentAnimationView.wkWebView.URL.description?_currentAnimationView.wkWebView.URL.description:(_currentAnimationView.uiWebView.request.URL.description?_currentAnimationView.uiWebView.request.URL.description:@"");
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
    if (_requestWithSignURL && self.supportBackBt) {
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
    if(_showType != 0) {
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



#pragma mark - private api
// 跳转控制器
- (void)_pushWebViewWithUrl:(NSString *)aUrl
{
    AMDWebViewController *webVc = [[AMDWebViewController alloc]init];
    webVc.requestWithSignURL = aUrl;
    webVc.showType = @1;
    [self.navigationController pushViewController:webVc animated:YES];
}




@end














