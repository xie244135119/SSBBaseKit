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


/**
 定时器无效
 */
- (void)invalidate;

@end



@protocol SSLinkageViewDelegate <NSObject>

@optional
// 点击事件
- (void)linkPageView:(SSLinkageView *)pageView index:(NSInteger)index;

@end











