//
//  SSFont.h
//  SSBaseKit
//  Kit框架中自定义字体 可以直接在扩展中修改字体
//  Created by SunSet on 2018/5/10.
//  Copyright © 2018年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSFont : UIFont


/**
 custom font
 
 @param fontSize 字体大小
 @return font
 */
+ (UIFont *)ssSystemFontOfSize:(CGFloat)fontSize;


/**
 custom bold font

 @param fontSize 字体大小
 @return font
 */
+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize;


@end



