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
 是否展示阴影
 */
@property (nonatomic, assign)BOOL showShadow;

/**
 是否显示分割线
 */
@property (nonatomic, assign)BOOL showDividingLine;

/**
 分割线高度 默认15
 */
@property (nonatomic)NSUInteger dividingLineHeight;

/**
 分割线颜色
 */
@property (nonatomic,strong)UIColor *dividingLineColor;
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
 支持排序的按钮下标从零开始 （双标排序）
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


#pragma mark - 支持单标
/**
 支持排序下标从零开始 @[@{@"index":0,@"items":@[@"",@"",@""]}]（单标排序,如果与双标冲突将覆盖双标）
 */
@property (nonatomic, strong)NSArray<NSDictionary *>* aloneSortIndexs;
/**
 承载菜单视图的父视图（如果需要支持单标，此属性必须赋值）
 */
@property (nonatomic, strong)UIView *senderView;
/**
 点击返回相应index以及相应被选择item的下标
 */
@property (nonatomic, copy)void(^aloneCompletion)(NSInteger index,NSUInteger sortStatus);


@end



