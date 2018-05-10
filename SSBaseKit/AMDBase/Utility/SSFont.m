//
//  SSFont.m
//  SSBaseKit
//
//  Created by SunSet on 2018/5/10.
//  Copyright © 2018年 SunSet. All rights reserved.
//

#import "SSFont.h"

@implementation SSFont

/**
 自定义font

 @param fontSize 字体大小
 @return font
 */
+ (UIFont *)ssSystemFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HiraginoSansGB-W3" size:fontSize];
}


+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HiraginoSansGB-W3" size:fontSize];
}



@end






