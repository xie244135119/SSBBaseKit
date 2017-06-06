//
//  AMDAnimationWebView.h
//  AppMicroDistribution
//  带动画的webView
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "YLJsBridgeSDK.h"
#import <WebKit/WebKit.h>
#import <SSBaseKit/AMDWebViewDelegate.h>
#import <SSBaseKit/AMDBaseView.h>
//@class YLJsBridgeSDK;

//#ifdef __IPHONE_8_0
//typedef void (^AMDWebViewAction)(WKWebView *webView);
//#else
//typedef void (^AMDWebViewAction)(UIWebView *webView);
//#endif


@interface AMDAnimationWebView : AMDBaseView


@property(nonatomic, copy) NSString *requestWithSignURL;
@property(nonatomic, weak) UILabel *websiteLabel;                       //网址标签
@property(nonatomic, weak) UIProgressView *progressView;                //加载的进度条

// 桥接sdk
//@property(nonatomic, strong) YLJsBridgeSDK *bridgeSDK;

//在当前webView中所有的a链接跳转新页面 默认NO
@property(nonatomic) BOOL linkNewPageFunction;

// webView的代理
@property(nonatomic, weak) id<AMDWebViewDelegate> delegate;


//#ifdef __IPHONE_8_0
@property(nonatomic, strong, readonly) WKWebView *wkWebView;                      //webView
//#else
@property(nonatomic, readonly) UIWebView *uiWebView;                      //webView
//#endif


#pragma mark -  页面请求完成后事件
@property(nonatomic, copy) void (^finishLoadAction_UI)(UIWebView *webView);               //加载完成后取的标题
@property(nonatomic, copy) void (^finishLoadAction_WK)(WKWebView *webView) NS_AVAILABLE_IOS(8_0);               //加载完成后取的标题

#pragma mark - 是否支持刷新
@property(nonatomic) BOOL supportRefresh;
//@property(nonatomic, copy) AMDWebViewAction reloadAction;         //重新刷新事件

@property(nonatomic, copy) void (^reloadAction_WK)(WKWebView *webView);               //加载完成后取的标题
@property(nonatomic, copy) void (^reloadAction_UI)(UIWebView *webView) NS_AVAILABLE_IOS(8_0);


@end








