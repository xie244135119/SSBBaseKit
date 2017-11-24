//
//  AMDCloseControl.m
//  SSBaseKit
//
//  Created by SunSet on 2017/10/17.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "AMDCloseControl.h"
#import <Masonry/Masonry.h>


@interface AMDCloseImgView : UIView

@property(nonatomic, strong) UIColor *lineColor;
@end


@implementation AMDCloseControl

- (void)dealloc
{
//    self.closeLineColor = nil;
}

//
- (id)initWithFrame:(CGRect)frame
          lineColor:(UIColor *)lineColor
{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = 18;
        //
        AMDCloseImgView *imgView = [[AMDCloseImgView alloc]init];
        imgView.lineColor = lineColor;
        imgView.userInteractionEnabled = NO;
        [self addSubview:imgView];
        if(CGRectEqualToRect(frame, CGRectZero)){
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@(width));
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY);
            }];
        }
        else {
            imgView.frame = CGRectMake((frame.size.width-width)/2, (frame.size.height-width)/2, width, width);
        }
    }
    return self;
}

@end


@implementation AMDCloseImgView
{
    CALayer *_shapeLayer;       //线条layer
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 清楚上下文
    [_shapeLayer removeFromSuperlayer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 0);
    CGPathAddLineToPoint(path, nil, self.frame.size.width,self.frame.size.height);
    CGPathMoveToPoint(path, nil, self.frame.size.width, 0);
    CGPathAddLineToPoint(path, nil,0, self.frame.size.height);
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path;
    layer.strokeColor = _lineColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1.5;
    [self.layer addSublayer:layer];
    CFRelease(path);
    _shapeLayer = layer;
}

@end





