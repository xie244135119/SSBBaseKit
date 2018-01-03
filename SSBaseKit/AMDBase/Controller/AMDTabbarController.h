//
//  AMDTabbarController.h
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSBaseKit/AMDTabbarItem.h>

@interface AMDTabbarController : UITabBarController

// 自定义tabbar
@property(nonatomic, weak , nullable) UIView *amdTabBar;


/**
 实例化

 @param titles 一组标题
 @param imgs 一组图片 可以为 UIImage, NSURL
 @param selectimgs 一组图片 可以为 UIImage, NSURL
 @return 一个实例
 */
-(nonnull instancetype)initWithItemsTitles:(NSArray * _Nonnull)titles
                        itemImages:(NSArray<id> * _Nonnull)imgs
                   itemSelctImages:(NSArray<id> * _Nonnull)selectimgs;


/**
 *  选中某一个Tabbar的版块
 *
 *  @param index 索引值
 */
- (void)selectTabbarIndex:(NSInteger)index;

@end



@interface UIViewController (AMDTabBarControllerItem)

// 自定义tabbarItem
@property(null_resettable, nonatomic, strong) AMDTabbarItem *amdTabBarItem;
// TabBarController
@property(nullable, nonatomic, readonly, strong) AMDTabbarController *amdTabBarController;

@end













