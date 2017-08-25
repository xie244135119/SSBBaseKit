//
//  AMDBackControl.m
//  AppMicroDistribution
//
//  Created by SunSet on 16/10/26.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AMDBackControl.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>

// 对号视图
@interface AMDBackImgView : UIView

// 线条颜色
@property(nonatomic, strong) UIColor *strokeColor;
@end


// 自定义后退按钮
@implementation AMDBackControl
{
//    __weak UIImageView *_imageView;
    __weak AMDBackImgView *_backImgView;            //对号视图
    
//    UIImage *_normalImage;          //正常状态下的图片
//    UIImage *_hightLightImage;      //高亮状态下的图片
}

- (void)dealloc
{
//    self.imageNormalName = nil;
//    self.imageSelectName = nil;
//    self.imageNormalName2 = nil;
//    self.imageSelectName2 = nil;
//    _normalImage = nil;
//    _hightLightImage = nil;
}

- (id)init
{
    if (self = [super init]) {
        [self initContentView2];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initContentView];
    }
    
    return self;
}

- (void)initContentView
{
    // 对号显示视图
    CGSize imgsize = CGSizeMake(14, 22);
    AMDBackImgView *imgView = [[AMDBackImgView alloc]initWithFrame:CGRectMake(10, (self.frame.size.height-imgsize.height)/2, imgsize.width, imgsize.height)];
    imgView.userInteractionEnabled = NO;
    [self addSubview:imgView];
    _backImgView = imgView;
    
    // 消息数量
    UILabel *messagecountlb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 44)];
    messagecountlb.font = SSFontWithName(@"", 13);
    messagecountlb.textColor = SSColorWithRGB(75, 75, 75, 1);
    [self addSubview:messagecountlb];
    _mesRemindLabel = messagecountlb;
}

- (void)initContentView2
{
    CGSize imgsize = CGSizeMake(14, 22);
    AMDBackImgView *imgView = [[AMDBackImgView alloc]init];
    imgView.userInteractionEnabled = NO;
    [self addSubview:imgView];
    _backImgView = imgView;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.height.equalTo(@(imgsize.height));
        make.width.equalTo(@(imgsize.width));
        make.centerY.equalTo(self);
    }];
    
    // 消息数量
    UILabel *messagecountlb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 44)];
    messagecountlb.font = SSFontWithName(@"", 13);
    messagecountlb.textColor = SSColorWithRGB(75, 75, 75, 1);
    [self addSubview:messagecountlb];
    _mesRemindLabel = messagecountlb;
    [messagecountlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(@44);
    }];
    
}


// 高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    // 选中的时候
//    if (_imageSelectName) {
//        _imageView.image = highlighted?[UIImage imageNamed:_imageSelectName]:[UIImage imageNamed:_imageNormalName];
//    }
//    
//    if (_imageSelectName2) {
//        _imageView.image = highlighted?[UIImage imageNamed:_imageSelectName2]:[UIImage imageNamed:_imageNormalName2];
//    }
//    
//    if (_hightLightImage) {
//        _imageView.image = highlighted?_hightLightImage:_normalImage;
//    }
//    
//    CGFloat red = 0;
//    CGFloat green = 0;
//    CGFloat blue = 0;
//    CGFloat alpha = 0;
//    [_imgStrokeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    // 如果颜色为白色
//    UIColor *highlightcolor = [UIColor colorWithRed:red green:blue blue:blue alpha:(CGFloat)alpha/2];
//    if ((red==255) && green==255 && blue==255 && alpha==1) {
        // 如果为白色
        UIColor *highlightcolor = [UIColor colorWithWhite:0 alpha:0.3];
//    }
    
//    if (highlighted) {
    
    _backImgView.strokeColor = highlighted?highlightcolor:_imgStrokeColor;
//    }
}


// 高亮状态
//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//    
//    // 选中的时候
//    if (_imageSelectName) {
//        _imageView.image = selected?[UIImage imageNamed:_imageSelectName]:[UIImage imageNamed:_imageNormalName];
//    }
//    
//    if (_imageSelectName2) {
//        _imageView.image = selected?[UIImage imageNamed:_imageSelectName2]:[UIImage imageNamed:_imageNormalName2];
//    }
//    
//    if (_hightLightImage) {
//        _imageView.image = selected?_hightLightImage:_normalImage;
//    }
//}




#pragma mark - SET方法
//- (void)setImageNormalName:(NSString *)imageNormalName
//{
//    if (_imageNormalName != imageNormalName) {
//        _imageNormalName = imageNormalName;
//        
//        if (imageNormalName) {
//            _imageView.image = [UIImage imageNamed:imageNormalName];
//            CGSize imagesize = _imageView.image.size;
//            _imageView.frame = CGRectMake(5, (self.frame.size.height-imagesize.height)/2, imagesize.width, imagesize.height);
//        }
//    }
//}
//
//- (void)setImageNormalName2:(NSString *)imageNormalName2
//{
//    if (_imageNormalName2 != imageNormalName2) {
//        _imageNormalName2 = imageNormalName2;
//        
//        if (imageNormalName2) {
//            _imageView.image = [UIImage imageNamed:imageNormalName2];
//        }
//    }
//}
//
//
//- (void)setImage:(UIImage *)image forState:(UIControlState)state
//{
//    switch (state) {
//        case UIControlStateNormal:      //正常
//        {
//            CGSize imagesize = image.size;
//            _imageView.frame = CGRectMake(5, (self.frame.size.height-imagesize.height)/2, imagesize.width, imagesize.height);
//            _imageView.image = image;
//            _normalImage = image;
//            
//            _backImgView.strokeColor = _imgStrokeColor;
//            
//            
//        }
//            break;
//        case UIControlStateHighlighted: //高亮
//         {
//             _hightLightImage = image;
//        
//             _backImgView.strokeColor = [UIColor colorWithWhite:0 alpha:0.5];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}




//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    // 开始点击
//    NSLog(@" 开始 ");
//    _backImgView.strokeColor = ;
//}
//
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    // 结束点击
//    NSLog(@" 结束 ");
//}


- (void)setImgStrokeColor:(UIColor *)imgStrokeColor
{
    if (_imgStrokeColor != imgStrokeColor) {
        _imgStrokeColor = imgStrokeColor;
        
        _backImgView.strokeColor = imgStrokeColor;
    }
}


@end



@implementation AMDBackImgView
{
    CALayer *_shapeLayer;       //线条layer
}

- (void)dealloc
{
    self.strokeColor = nil;
}

- (void)drawRect:(CGRect)rect
{
    [_shapeLayer removeFromSuperlayer];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    //    CGPoint startpoint = CGPointMake(0, width);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, width, 0);
    CGPathAddLineToPoint(path, nil, 2, height/2);
    CGPathAddLineToPoint(path, nil, width, height);
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path;
    layer.strokeColor = _strokeColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 2;
    layer.lineJoin = @"round";
    [self.layer addSublayer:layer];
    _shapeLayer = layer;
}


- (void)setStrokeColor:(UIColor *)strokeColor
{
    if (_strokeColor != strokeColor) {
        _strokeColor = strokeColor;
        
        // 重绘
        [self setNeedsDisplay];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end









