//
//  SSArrowView.m
//  SSBaseKit
//
//  Created by Sherry on 2018/11/5.
//  Copyright © 2018年 SunSet. All rights reserved.
//

#import "SSArrowView.h"

@implementation SSArrowView

- (void)prepareViewWithDirection:(SSArrowViewDirection)direction{
    switch (direction) {
        case SSArrowViewDirectionTop:
            [self topView];
            break;
        case SSArrowViewDirectionBottom:
            [self bottomView];
            break;
        case SSArrowViewDirectionLeft:
            [self leftView];
            break;
        case SSArrowViewDirectionRight:
            [self rightView];
            break;
            
        default:
            break;
    }
}


- (void)topView{
    CGRect frame = self.frame;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(frame.size.width/2,0)];
    [path addLineToPoint:CGPointMake(frame.size.width,frame.size.height)];
    [path addLineToPoint:CGPointMake(0, frame.size.height)];
    [path closePath];
    [path fill];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

- (void)bottomView{
    CGRect frame = self.frame;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(frame.size.width,0)];
    [path addLineToPoint:CGPointMake(frame.size.width/2, frame.size.height)];
    [path closePath];
    [path fill];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

- (void)leftView{
    CGRect frame = self.frame;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(0,frame.size.height/2)];
    [path addLineToPoint:CGPointMake(frame.size.width,0)];
    [path addLineToPoint:CGPointMake(frame.size.width, frame.size.height)];
    [path closePath];
    [path fill];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

- (void)rightView{
    CGRect frame = self.frame;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(frame.size.width,frame.size.height/2)];
    [path addLineToPoint:CGPointMake(0, frame.size.height)];
    [path closePath];
    [path fill];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}


@end
