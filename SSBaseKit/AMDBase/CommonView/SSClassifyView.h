//
//  SSClassifyView.h
//  SSClassifyViewDemo
//
//  Created by 马清霞 on 2018/4/12.
//  Copyright © 2018年 Sherry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSBaseKit/AMDButton.h>

@class SSClassifyView;

@protocol SSClassifyDataSource<NSObject>

@optional
// 自定义配置每一个item 如果不实现，则默认使用 imageSize为{44，44} title
//- (void)classify;

/**
 @return 一组分类标题
 */
- (NSArray<NSString *> *)classifyTitles;

/**
 @return 一组分类图片地址
 */
- (NSArray<NSURL *> *)classifyImageUrls;
@end


@protocol SSClassifyDelegate<NSObject>

@optional
// 选中效果
- (void)classiftView:(SSClassifyView *)view didSelectAtIndex:(NSInteger)index;
@end


typedef NS_ENUM(NSUInteger, SSClassifyDirection) {
    SSClassifyVertical,                    //垂直方向
//    SSClassifyHorizontal,               //水平     <暂不支持>
};

@interface SSClassifyView : UIView

/**
 一屏内item 数量 默认为5
 */
@property(nonatomic, assign) NSInteger visableItemCount;

/**
 视图布局方向，默认为垂直
 */
@property(nonatomic) SSClassifyDirection direcrion;

/**
 每行高度,默认为65
 */
@property(nonatomic, assign) CGFloat rowHeight;

/**
 行间距 默认0（direction 为SSClassifyVertical 有效）
 */
@property(nonatomic, assign) CGFloat rowSpace;

/**
 图片视图尺寸 默认{44， 44}
 */
@property(nonatomic, assign) CGSize imageSize;

/**
 图片圆角
 */
@property(nonatomic, assign) CGFloat imageCornerRadius;

/**
 标题label字体 默认系统字体 10
 */
@property(nonatomic, strong) UIFont *titleFont;

/**
 标题字体颜色
 */
@property(nonatomic, strong) UIColor *titleColor;


/**
 数据源
 */
@property (nonatomic,weak) id<SSClassifyDataSource> dataSource;


/**
 点击事件
 */
@property (nonatomic,weak) id<SSClassifyDelegate>delegate;


/**
 预加载
 */
- (void)prepareForLoad;

/**
 重新加载
 */
- (void)reload;







/**
 初始化分类视图(不带标题,自动布局下视图width默认self.frame.size.width)

 @pram frame 视图位置（高度是通过布局之后动态计算出的）
 @param count 一行最多放几个item数量 可不传 默认5
 @param sourceArray 数据源
 @param height item高度 （默认间隔10）
 @param isogony item是否等宽等高 默认No
 @return 实例化对象
 */
//+ (instancetype)initWithFrame:(CGRect)frame
//                  maxRowCount:(NSUInteger)count
//                  sourceArray:(NSArray<AppEntFeatureModel> *)sourceArray
//               classifyHeight:(CGFloat)height
//                      isogony:(BOOL)isogony;


/**
 带有标题的分类视图

 @param frame 视图位置（高度是通过布局之后动态计算出的）
 @param count 一行最多放几个item数量 可不传 默认5
 @param sourceArray  数据源
 @param height item高度 （默认间隔10）
 @param isogony  item是否等宽等高 默认No
 @return 实例化对象
 */
//+ (instancetype)initClassifyWithFrame:(CGRect)frame
//                  maxRowCount:(NSUInteger)count
//                  sourceArray:(NSArray<AppEntFeatureModel> *)sourceArray
//               classifyHeight:(CGFloat)height
//                      isogony:(BOOL)isogony;
//
//
////点击每一个item的触发方法
//@property (nonatomic, copy) void(^clickItem)(AppEntFeatureModel  *model);




@end





















