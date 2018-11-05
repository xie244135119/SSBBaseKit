//
//  SSSortButton.h
//  SSSelectItem
//  支持排序的button
//  Created by Sherry on 2018/8/22.
//  Copyright © 2018年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SSSortButton : UIControl

//是否支持排序
@property (nonatomic, assign)BOOL sort;

//title
@property (nonatomic, strong)UILabel *titleLabel;

//排序状态 （0、默认无序 1、升序  2、降序）
@property (nonatomic, assign)NSUInteger status;

@property (nonatomic, strong)UIColor *arrowColor;

/**
 箭头颜色(选中)
 */
@property (nonatomic, strong)UIColor *arrowSelectColor;

@end
