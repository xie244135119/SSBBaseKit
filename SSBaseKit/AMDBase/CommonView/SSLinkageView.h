//
//  XQLinkageView.h
//
//  自滚动页面
//  Created by SunSet on 14-12-2.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol SSLinkageViewDelegate;

@interface SSLinkageView : UIView


@property(nonatomic, weak) id<SSLinkageViewDelegate> delegate;

/**
 滚动视图
 */
@property(nonatomic, readonly) UIScrollView *scrollView;

/**
 pageControl
 */
@property(nonatomic, weak) UIPageControl *currentPageControl;

/**
 一组请求地址
 */
@property(nonatomic, strong, readwrite) NSArray<NSURL *> *imageURLs;

/**
 轮播时间 默认为5s
 */
@property(nonatomic, assign) NSInteger linkageDuration;


/**
 实例化

 @param frame frame
 @param imageUrls 图片没名称
 @return 实例化
 */
- (instancetype)initWithFrame:(CGRect)frame
                    imageUrls:(NSArray *)imageUrls;
- (instancetype)initWithImageUrls:(NSArray *)imageUrls;


/**
 定时器无效
 */
- (void)invalidate;

/**
 预加载
 */
- (void)prepareLoad;

@end



@protocol SSLinkageViewDelegate <NSObject>

@optional

/**
 点击事件
 NS_DEPRECATED_IOS(2_0, 8_0, "Use -linkPageView:actionAtIndex:")
 @param pageView 当前视图
 @param index 当前索引
 */
- (void)linkPageView:(SSLinkageView *)pageView
               index:(NSInteger)index ;
- (void)linkPageView:(SSLinkageView *)pageView
       actionAtIndex:(NSInteger)index;


/**
 即将滑动到某个视图
 (注：由于视图会重用，请调用方自行处理重用问题)
 @param pageView pageView
 @param imageView 即将滑动展现的视图
 @param index 索引
 */
- (void)linkPageView:(SSLinkageView *)pageView
    willScrollToImage:(UIView *)imageView
             atIndex:(NSInteger)index;
- (void)linkPageView:(SSLinkageView *)pageView
    didScrollToImage:(UIView *)imageView
             atIndex:(NSInteger)index;

@end











