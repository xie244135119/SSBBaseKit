//
//  UIImage+TintColor.h
//  AppLeaderTuan
//
//  Created by SunSet on 2018/12/5.
//  Copyright © 2018 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TintColor)


/**
 根据颜色改变图片样式

 @param color 需要渲染的颜色
 @return image
 */
- (UIImage *)imageTintedWithColor:(UIColor *)color;



@end



