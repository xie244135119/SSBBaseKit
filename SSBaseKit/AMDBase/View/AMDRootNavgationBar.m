//
//  AMDRootNavgationBar.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDRootNavgationBar.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>

@interface AMDRootNavgationBar()
{
    CGFloat _maxLeftWidth;              //左侧最大宽度
    CGFloat _maxRightWidth;             //右侧最大宽度
}
@end

@implementation AMDRootNavgationBar

- (void)dealloc
{
    self.naviationBar=nil;
    self.leftViews=nil;
    self.rightViews=nil;
    self.backgroundimage=nil;
    self.title=nil;
    self.naviationBarColor = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 导航栏
        UINavigationBar *bar = [[UINavigationBar alloc]init];
        _naviationBar = bar;
        bar.translucent = NO;
        [self addSubview:bar];
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            //            make.top.equalTo(@0);
        }];
        
        // 标题
        UILabel *label = [[UILabel alloc]init];
        _titleLabel = label;
        label.tag = 10;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = SSFontWithName(@"", 18);
        label.textColor = SSColorWithRGB(75, 75, 75, 1);
        label.preferredMaxLayoutWidth = SScreenWidth-100;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
            make.bottom.equalTo(@0);
            make.left.equalTo(@50);
            make.right.equalTo(@-50);
        }];
        // 调整文本
        [self _adjustTitleLabel];
        
        // 加载初始化配置
        [self initConfig];
    }
    return self;
}


#pragma mark - 适配ios11
// 安全区域变化
//- (void)safeAreaInsetsDidChange
//{
//    [super safeAreaInsetsDidChange];
//    
//    // 适配ios11 iphonex
//    __weak typeof(self) weakself = self;
////    [_naviationBar mas_updateConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(@(-weakself.safeAreaInsets.top));
////        NSLog(@" 置顶: %f ",weakself.safeAreaInsets.top);
////    }];
//}


#pragma mark 重写属性的Set方法
- (void)setLeftViews:(NSArray *)leftViews
{
    if (_leftViews!=leftViews) {
        _leftViews = leftViews;
        
        if (_leftViews.count > 0) {
            _maxLeftWidth = 0;
            for (UIView *v in leftViews ) {//添加页面
                [self addSubview:v];
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(v.frame.size.width));
                    make.bottom.equalTo(@((v.frame.size.height-44)/2));
                    make.left.equalTo(@(v.frame.origin.x));
                    make.height.equalTo(@(v.frame.size.height));
                }];
                _maxLeftWidth += (v.frame.size.width+v.frame.origin.x);
            }
            // 调整标题大小
            [self _adjustTitleLabel];
        }
    }
}


- (void)setRightViews:(NSArray *)rightViews
{
    if (_rightViews != rightViews) {
        _rightViews = rightViews;
        
        if (_rightViews.count > 0) {
            _maxRightWidth = 0;
            for (UIView *v in rightViews ) {//添加页面
                [self addSubview:v];
                [v mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(v.frame.size.width));
                    make.bottom.equalTo(@((v.frame.size.height-44)/2));
                    make.left.equalTo(@(v.frame.origin.x));
                    make.height.equalTo(@(v.frame.size.height));
                }];
                _maxRightWidth = MAX(_maxRightWidth, SScreenWidth-v.frame.origin.x);
            }
            // 调整标题大小
            [self _adjustTitleLabel];
        }
    }
}

// 设置标题
- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        
//        if (title.length > 0) {
            _titleLabel.text = title;
//        }
    }
}


- (void)setBackgroundimage:(UIImage *)backgroundimage
{
    if (_backgroundimage!=backgroundimage) {
        _backgroundimage=backgroundimage;
        [_naviationBar setBackgroundImage:backgroundimage forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setNaviationBarColor:(UIColor *)naviationBarColor
{
    if (_naviationBarColor != naviationBarColor) {
        _naviationBarColor = naviationBarColor;
        [_naviationBar setBarTintColor:naviationBarColor];
        self.backgroundColor = naviationBarColor;
        
        _naviationBar.alpha = ![naviationBarColor isEqual:[UIColor clearColor]];
    }
}


#pragma mark - private api
// 调整titlelabel大小
- (void)_adjustTitleLabel
{
    CGFloat maxreduce = MAX(_maxRightWidth, _maxLeftWidth);
    maxreduce = MAX(maxreduce, 50);
    // 最大宽度不能超过中间位置
    maxreduce = MIN(maxreduce, (SScreenWidth-40)/2);
    if (maxreduce > 0) {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(maxreduce));
            make.right.equalTo(@(-maxreduce));
        }];
    }
}

// 初始化配置
- (void)initConfig
{
    // 设置背景色
    UIColor *backgroundcolor = [[UINavigationBar appearance] barTintColor];
    if (backgroundcolor) {
        [self setNaviationBarColor:backgroundcolor];
    }
    
    // 设置文字颜色
    UIColor *textcolor = [[[UINavigationBar appearance] titleTextAttributes] objectForKey:NSForegroundColorAttributeName];
    if (textcolor) {
        _titleLabel.textColor = textcolor;
    }
}



@end








