//
//  SSPageViewController.h
//  AppMicroDistribution
//  翻页视图
//  Created by SunSet on 2018/12/5.
//  Copyright © 2018 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SSPageViewControllerDelegate;

@interface SSPageViewController : UIViewController

// pageViewController
@property(nonatomic, strong) UIPageViewController *pageViewController;
// 一组控制器
@property(nonatomic, readonly) NSArray<UIViewController *> *controllers;
//
@property(nonatomic, weak) id<SSPageViewControllerDelegate> delegate;


/**
 构造器

 @param controllers 一组控制器
 @return 当前实例
 */
- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers;


@end



@protocol SSPageViewControllerDelegate<NSObject>

@optional
// 当视图发生改变的时候
- (void)controller:(SSPageViewController *)controller
visableControllerChanged:(UIViewController *)controller
      visableIndex:(NSInteger)index;


@end



