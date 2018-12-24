//
//  UIImage+TintColor.m
//  AppLeaderTuan
//
//  Created by SunSet on 2018/12/5.
//  Copyright © 2018 SunSet. All rights reserved.
//

#import "UIImage+TintColor.h"

@implementation UIImage (TintColor)


// 根据颜色生成改变图片
- (UIImage *)imageTintedWithColor:(UIColor *)color{
    if (color) {
        // Construct new image the same size as this one.
        UIImage *image;
        
        if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
            UIGraphicsBeginImageContextWithOptions([self size], NO, 0.f); // 0.f for scale means "scale for device's main screen".
        } else {
            UIGraphicsBeginImageContext([self size]);
        }
        
        CGRect rect = CGRectZero;
        rect.size = [self size];
        
        // Composite tint color at its own opacity.
        [color set];
        UIRectFill(rect);
        
        // Mask tint color-swatch to this image's opaque mask.
        // We want behaviour like NSCompositeDestinationIn on Mac OS X.
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
        
        // Finally, composite this image over the tinted mask at desired opacity.
//        if (fraction > 0.0) {
//            // We want behaviour like NSCompositeSourceOver on Mac OS X.
//            [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
//        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    return self;
}




@end



