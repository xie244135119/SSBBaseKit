//
//  AMDImgViewLabelView.h
//  AppMicroDistribution
//  左侧imageView 文本内容 右侧箭头
//  Created by SunSet on 15-5-26.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDImgViewLabelView : UIControl

// 图像
@property(nonatomic, weak) UIImageView *headImgView;
// 文本内容
@property(nonatomic, weak) UILabel *textLabel;
// 是否支持箭头 默认是YES
@property(nonatomic) BOOL supportArrows;


@end
