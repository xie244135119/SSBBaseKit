//
//  AMDCloseControl.h
//  SSBaseKit
//
//  Created by SunSet on 2017/10/17.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDCloseControl : UIControl

// 关闭线条的颜色
//@property(nonatomic, strong) UIColor *closeLineColor;


/**
 实例化

 @param frame 大小
 @param lineColor 颜色
 @return 实例
 */
- (id)initWithFrame:(CGRect)frame
          lineColor:(UIColor *)lineColor;

@end



