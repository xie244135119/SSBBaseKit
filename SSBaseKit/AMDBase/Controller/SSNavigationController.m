//
//  SSNavigationController.m
//  AppMicroDistribution
//
//  Created by SunSet on 2017/11/3.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "SSNavigationController.h"
#import <SSBaseKit/AMDRootViewController.h>

@interface SSNavigationController ()

@end

@implementation SSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - api
//
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 设置后退按钮
    if(self.viewControllers.count > 0) {
        if ([viewController isKindOfClass:[AMDRootViewController class]]) {
            AMDRootViewController *Vc = (AMDRootViewController *)viewController;
            Vc.supportBack = YES;
        }
    }
    
    [super pushViewController:viewController animated:animated];
}



@end
