//
//  AMDBackControl.m
//  AppMicroDistribution
//
//  Created by SunSet on 16/10/26.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AMDBackControl.h"
#import "SSGlobalVar.h"
#import "Masonry.h"

// 自定义后退按钮
@implementation AMDBackControl
{
    __weak UIImageView *_imageView;
    
    UIImage *_normalImage;          //正常状态下的图片
    UIImage *_hightLightImage;      //高亮状态下的图片
}

- (void)dealloc
{
    self.imageNormalName = nil;
    self.imageSelectName = nil;
    self.imageNormalName2 = nil;
    self.imageSelectName2 = nil;
    _normalImage = nil;
    _hightLightImage = nil;
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
    // 图片
    UIImageView *imgView = [[UIImageView alloc]init];
    [self addSubview:imgView];
    //        imgView.layer.borderWidth = 1;
    _imageView = imgView;
    
    // 消息数量
    UILabel *messagecountlb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 44)];
    messagecountlb.font = FontWithName(@"", 13);
    messagecountlb.textColor = ColorWithRGB(75, 75, 75, 1);
    [self addSubview:messagecountlb];
    _mesRemindLabel = messagecountlb;
}

- (void)initContentView2
{
    // 图片
    UIImageView *imgView = [[UIImageView alloc]init];
    [self addSubview:imgView];
    _imageView = imgView;
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.height.width.equalTo(@(24));
        make.centerY.equalTo(self);
    }];
    
    // 消息数量
    UILabel *messagecountlb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 44)];
    messagecountlb.font = FontWithName(@"", 13);
    messagecountlb.textColor = ColorWithRGB(75, 75, 75, 1);
    [self addSubview:messagecountlb];
    _mesRemindLabel = messagecountlb;
    [messagecountlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(@44);
    }];
    
}

//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//
//    //选中的时候
//    _imageView.image = selected?[UIImage imageNamed:_imageSelectName]:[UIImage imageNamed:_imageNormalName];
//}

// 高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    // 选中的时候
    if (_imageSelectName) {
        _imageView.image = highlighted?[UIImage imageNamed:_imageSelectName]:[UIImage imageNamed:_imageNormalName];
    }
    
    if (_imageSelectName2) {
        _imageView.image = highlighted?[UIImage imageNamed:_imageSelectName2]:[UIImage imageNamed:_imageNormalName2];
    }
    
    if (_hightLightImage) {
        _imageView.image = highlighted?_hightLightImage:_normalImage;
    }
}


// 高亮状态
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // 选中的时候
    if (_imageSelectName) {
        _imageView.image = selected?[UIImage imageNamed:_imageSelectName]:[UIImage imageNamed:_imageNormalName];
    }
    
    if (_imageSelectName2) {
        _imageView.image = selected?[UIImage imageNamed:_imageSelectName2]:[UIImage imageNamed:_imageNormalName2];
    }
    
    if (_hightLightImage) {
        _imageView.image = selected?_hightLightImage:_normalImage;
    }
}




#pragma mark - SET方法
- (void)setImageNormalName:(NSString *)imageNormalName
{
    if (_imageNormalName != imageNormalName) {
        _imageNormalName = imageNormalName;
        
        if (imageNormalName) {
            _imageView.image = [UIImage imageNamed:imageNormalName];
            CGSize imagesize = _imageView.image.size;
            _imageView.frame = CGRectMake(5, (self.frame.size.height-imagesize.height)/2, imagesize.width, imagesize.height);
        }
    }
}

- (void)setImageNormalName2:(NSString *)imageNormalName2
{
    if (_imageNormalName2 != imageNormalName2) {
        _imageNormalName2 = imageNormalName2;
        
        if (imageNormalName2) {
            _imageView.image = [UIImage imageNamed:imageNormalName2];
        }
    }
}


- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    switch (state) {
        case UIControlStateNormal:      //正常
        {
            CGSize imagesize = image.size;
            _imageView.frame = CGRectMake(5, (self.frame.size.height-imagesize.height)/2, imagesize.width, imagesize.height);
            _imageView.image = image;
            _normalImage = image;
        }
            break;
        case UIControlStateHighlighted: //高亮
            _hightLightImage = image;
            break;
            
        default:
            break;
    }
}




#pragma mark - 重写父类方法获取点击
//开始点击的时候
//- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    [self setSelected:YES];
//    return YES;
//}
//
////取消点击的时候
//- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    [self setSelected:NO];
//}
//
//- (void)cancelTrackingWithEvent:(UIEvent *)event
//{
//    [self setSelected:NO];
//}

@end

