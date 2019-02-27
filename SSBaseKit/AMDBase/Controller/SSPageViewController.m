//
//  SSPageViewController.m
//  AppMicroDistribution
//
//  Created by SunSet on 2018/12/5.
//  Copyright © 2018 SunSet. All rights reserved.
//

#import "SSPageViewController.h"
#import <Masonry/Masonry.h>

@interface SSPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation SSPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 视图加载
    [self p_setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _controllers = controllers;
    }
    return self;
}


#pragma mark - 视图初始化
// 视图初始化
- (void)p_setupViews {
    UIPageViewController *pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                        options:nil];
    pageController.delegate = self;
    pageController.dataSource = self;
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    [pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    _pageViewController = pageController;
    [pageController setViewControllers:@[_controllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        NSLog(@"加载完成");
    }];
}


#pragma mark - UIPageViewControllerDataSource
//
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
               viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [_controllers indexOfObject:viewController];
    if (index == 0) {
        // 第一个
        return nil;
    }
    index--;
    return _controllers[index];
}

//
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [_controllers indexOfObject:viewController];
    if (index == _controllers.count-1) {
        // 最后一个
        return nil;
    }
    index++;
    return _controllers[index];
}


#pragma mark -
// 视图控制器切换完成之后
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (completed) {
        NSInteger index = [_controllers indexOfObject:[pageViewController.viewControllers lastObject]];
        if ([_delegate respondsToSelector:@selector(controller:visableControllerChanged:visableIndex:)]) {
            [_delegate controller:self
         visableControllerChanged:[pageViewController.viewControllers lastObject]
                     visableIndex:index];
        }
    }
}




@end








