//
//  AMDTabbarItem.h
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMDImageView.h"

@interface AMDTabbarItem : UIControl


// 显示的标题
@property(nonatomic,readonly,weak) UILabel *itemTitleLabel;

// 显示的图片
@property(nonatomic,strong) UIImage *itemSelectImage;
@property(nonatomic,readonly,weak) AMDImageView *itemImageView;

// 支持选中动画
@property(nonatomic) BOOL supportAnimation;
// 设置提醒数量  0不显示 -2 显示红点 其余正常显示
@property(nonatomic, assign) NSInteger remindNumber;


/**
 // 根据不同的状态设置不同的图片

 @param image UIImage 或 NSUrl
 @param state 状态
 */
- (void)setImage:(UIImage *)image controlState:(UIControlState)state;
- (void)setImageUrl:(NSURL *)imageUrl controlState:(UIControlState)state;

// 根据不同的状态设置不同
- (void)setTitleColor:(UIColor *)titleColor controlState:(UIControlState)state;

@end









