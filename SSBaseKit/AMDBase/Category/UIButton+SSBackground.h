//
//  UIButton+AYEButtonBackground.h
//  AppMicroDistribution
//
//  Created by leo on 16/4/5.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SSBackground)


/**
 设置button 背景色效果

 @param color <#color description#>
 @param state <#state description#>
 */
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end
