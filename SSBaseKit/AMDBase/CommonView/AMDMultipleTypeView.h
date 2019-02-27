//
//  AMDMultipleTypeView.h
//  AppMicroDistribution
//  多类型视图
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMDMultipleTypeView;


@protocol AMDMultipleTypeChoiceDelegate <NSObject>

@optional
//sender:点击的响应控件  tag 按位置来 起始位置:1
- (void)messageChoiceView:(AMDMultipleTypeView *)view
                   sender:(UIButton *)sender;
//
- (void)messageChoiceView:(AMDMultipleTypeView *)view
               fromButton:(UIButton *)fromButton
                 toButton:(UIButton *)toButton;
@end

@interface AMDMultipleTypeView : UIView
// 少于4个均分 多于4个滚动

// 委托实例
@property(nonatomic, weak) id<AMDMultipleTypeChoiceDelegate> delegate;
// 数据源--一组标题
@property(nonatomic, strong, readonly) NSArray<NSString *> *multitles;
// 设置文本字体大小
@property(nonatomic, strong) UIFont *titleFont;
// 选中的时候文本字体
@property(nonatomic, strong) UIFont *titleSelectFont;
// 设置正常时候的文本
@property(nonatomic, strong) UIColor *textNormalColor;
// 选中时候的文本
@property(nonatomic, strong) UIColor *textSelectColor;
// 底部阴影颜色
@property(nonatomic, strong) UIColor *shadowColor;
// 最大阴影显示宽度
@property(nonatomic) CGFloat maxShadowWidth;

/** 当前点击的按钮索引 从1开始 */
@property(nonatomic,assign) NSInteger currentClickIndex;


// 是否支持分割线 默认为NO
@property(nonatomic) BOOL supportSeparatorLine;


/**
 *  @param frame  大小
 *  @param titles 所有标签名称
 *  @return Button
 */
- (nullable instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
/**
 *  支持AutoLayout
 *
 */
- (nullable instancetype)initWithTitles:(NSArray *)titles;


// 选择某个tab 索引从1开始
- (void)selectChoiceAtIndex:(NSInteger)index;
// 根据需要 返回的按钮 index:索引值(1开始)
- (UIButton *)buttonWithIndex:(NSInteger)index;

// 默认高度
+ (CGFloat)defaultHeight;


@end









