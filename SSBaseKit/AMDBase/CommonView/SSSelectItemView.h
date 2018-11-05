//
//  SSSelectItemView.h
//  SSSelectItem
//
//  Created by Sherry on 2018/8/22.
//  Copyright © 2018年 Sherry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSSelectItemView : UIView

/**
 文字大小
 */
@property (nonatomic, assign)UIFont *titleFont;

/**
 文字颜色
 */
@property (nonatomic, strong)UIColor *titleColor;

/**
 文字选中色
 */
@property (nonatomic, strong)UIColor *titleSelectedColor;

/**
 箭头颜色
 */
@property (nonatomic, strong)UIColor *arrowColor;

/**
 箭头颜色(选中)
 */
@property (nonatomic, strong)UIColor *arrowSelectColor;

/**
 每页支持最大item数量  总item数超过maxCount支持滑动翻页
 */
@property (nonatomic, assign)NSUInteger maxCount;

/**
 标题
 */
@property (nonatomic, strong)NSArray<NSString *> *titles;

/**
 支持排序的按钮下标从零开始
 */
@property (nonatomic, strong)NSArray<NSNumber *>* sortIndexs;

/**
 点击返回相应item坐标以及升降序状态
 */
@property (nonatomic, copy)void(^completion)(NSInteger index,NSUInteger sortStatus);

/**
 开始渲染
 */
- (void)prepareView;


@end



