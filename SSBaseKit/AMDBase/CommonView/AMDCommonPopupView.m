//
//  AMDCommonPopupView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-11-10.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDCommonPopupView.h"

@interface AMDCommonPopupView()
{
    __weak UIView *_middleView;                 //中间视图
}
@end

@implementation AMDCommonPopupView


- (id)init
{
    if (self = [super initWithFrame:CGRectMake(0, 0, self.frame.size.width, APPHeight)]) {
        [self initContentView];
    }
    return self;
}

// 视图加载
- (void)initContentView
{
    self.backgroundColor = ColorWithRGB(0, 0, 0, 0);
    
    // 中间视图
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, APPHeight, APPWidth, 170)];
    middleView.backgroundColor = ColorWithRGB(246, 246, 246, 1);
    [self addSubview:middleView];
    _middleView = middleView;
    
    //取消按钮
    /*AMDButton *cancelbt = [[AMDButton alloc]initWithFrame:CGRectMake(0, 120, APPWidth, 50)];
     cancelbt.titleLabel.text = @"取消";
     cancelbt.titleLabel.textColor = ColorWithRGB(51, 51, 51, 1);
     [cancelbt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [cancelbt setBackgroundColor:AMDLineColor forState:UIControlStateHighlighted];
     [middleView addSubview:cancelbt];
     cancelbt.tag = 3;
     [cancelbt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];*/
    
    //线条
    AMDLineView *middleline = [[AMDLineView alloc]initWithFrame:CGRectMake(0, 50, APPWidth, AMDLineHeight) Color:AMDLineColor];
    [_middleView addSubview:middleline];
    AMDLineView *topline = [[AMDLineView alloc]initWithFrame:CGRectMake(0, 120, APPWidth, AMDLineHeight) Color:AMDLineColor];
    [_middleView addSubview:topline];
}

// 显示视图
- (void)show
{
    //添加视图
    /*AppDelegate *app = [(UIApplication *)[UIApplication sharedApplication] delegate];
     [app.window addSubview:self];
     
     __weak typeof(self) weakself = self;
     [UIView animateWithDuration:0.25 animations:^{
     _middleView.frame = CGRectMake(0, APPHeight-_middleView.frame.size.height, APPWidth, _middleView.frame.size.height);
     weakself.backgroundColor = ColorWithRGB(0, 0, 0, 0.56);
     }];*/
}

// 隐藏视图
- (void)hide
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.25 animations:^{
        _middleView.frame = CGRectMake(0, APPHeight, APPWidth, _middleView.frame.size.height);
        weakself.backgroundColor = ColorWithRGB(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
}



#pragma mark - UITouch事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:_middleView]) {
        return;
    }
    [self hide];
}



#pragma mark - 按钮事件
- (void)clickAction:(UIButton *)sender
{
    
}


@end






















