//
//  AMDImgViewLabelView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-26.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDImgViewLabelView.h"
#import "SSGlobalVar.h"

@implementation AMDImgViewLabelView
{
    __weak UIImageView *_jiantouImgView;            //箭头视图
    
    BOOL _autoLayout;                               //自动布局
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (_autoLayout) {
            [self initAutoLayoutView];
        }
        else {
            [self initContentView];
        }
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        //
        _autoLayout = YES;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    //有点击事件
    if (_supportArrows) {
        self.backgroundColor = highlighted ?SSLineColor:[UIColor whiteColor];
    }
}


- (void)initContentView
{
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    // 图片视图
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (h-25)/2, 25, 25)];
    [self addSubview:imgView];
    _headImgView = imgView;
    
    // 文本内容
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, w-50-40, h)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = FontWithName(@"", 14);
    [self addSubview:textLabel];
    _textLabel = textLabel;
    
    //箭头
    NSString *arrowpath = GetFilePathFromBundle(@"CommonUIModule.bundle", @"arrow-right.png");
    UIImage *arrowiamge = [[UIImage alloc]initWithContentsOfFile:arrowpath];
    UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(w-30, (h-24)/2, 24, 24)];
    jiantou.image = arrowiamge;
    [self addSubview:jiantou];
    _jiantouImgView = jiantou;
    
    _supportArrows = YES;
}

// 还未改造完成
- (void)initAutoLayoutView
{
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    
    // 图片视图
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (h-25)/2, 25, 25)];
    [self addSubview:imgView];
    _headImgView = imgView;
    
    // 文本内容
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, w-50-40, h)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = FontWithName(@"", 14);
    [self addSubview:textLabel];
    _textLabel = textLabel;
    
    //箭头
    NSString *arrowpath = GetFilePathFromBundle(@"CommonUIModule.bundle", @"arrow-right.png");
    UIImage *arrowiamge = [[UIImage alloc]initWithContentsOfFile:arrowpath];
    UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(w-30, (h-24)/2, 24, 24)];
    jiantou.image = arrowiamge;
    [self addSubview:jiantou];
    _jiantouImgView = jiantou;
    
    _supportArrows = YES;
}



#pragma mark - SET
- (void)setSupportArrows:(BOOL)supportArrows
{
    if (_supportArrows != supportArrows) {
        _supportArrows = supportArrows;
        
        _jiantouImgView.hidden = !supportArrows;
    }
}



@end












