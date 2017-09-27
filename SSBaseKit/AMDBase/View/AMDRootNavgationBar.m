//
//  AMDRootNavgationBar.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDRootNavgationBar.h"
#import "SSGlobalVar.h"

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
        CGRect statusframe = [[UIApplication sharedApplication] statusBarFrame];
        UINavigationBar *bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, statusframe.size.height, SScreenWidth, 44)];
        _naviationBar = bar;
        bar.translucent = NO;
        [self addSubview:bar];
     
        self.frame = CGRectMake(0, 0, bar.frame.size.width, bar.frame.size.height+bar.frame.origin.y);
    }
    return self;
}


#pragma mark
#pragma mark 重写属性的Set方法
- (void)setLeftViews:(NSArray *)leftViews
{
    if (_leftViews!=leftViews) {
        _leftViews=leftViews;
        
        NSInteger height = self.frame.size.height;
        for (UIView *v in leftViews ) {//添加页面
            CGRect rect = v.frame;
            CGFloat y = height-44+((height-44)-v.frame.size.height)/2;
            v.frame = CGRectMake(rect.origin.x, y, v.frame.size.width, v.frame.size.height);
            [self addSubview:v];
        }
    }
}


- (void)setRightViews:(NSArray *)rightViews
{
    if (_rightViews!=rightViews) {
        _rightViews=rightViews;
        
        NSInteger height = self.frame.size.height;
        for (UIView *v in rightViews ) {//添加页面
            CGRect rect = v.frame;
            CGFloat y = (height-44)+((height-44)-v.frame.size.height)/2;
            v.frame = CGRectMake(rect.origin.x, y, v.frame.size.width, v.frame.size.height);
            [self addSubview:v];
        }
    }
}


- (void)setTitle:(NSString *)title
{//设置标题
    if (_title!=title) {
        _title=title;
        
        NSInteger height = self.frame.size.height;
        if (_titleLabel == nil) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, (height-44), self.frame.size.width-80, 44)];
            _titleLabel = label;
            label.tag = 10;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = SSFontWithName(@"", 18);
            label.textColor = SSColorWithRGB(75, 75, 75, 1);
            [self addSubview:label];
        }
        
        // 设置frame
        CGFloat rightw = 10;
        for (UIView *v in _rightViews) {
            rightw += v.frame.size.width;
        }
        
        NSMutableParagraphStyle *parstyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        parstyle.lineBreakMode = NSLineBreakByWordWrapping;
        parstyle.lineSpacing = 2;
        NSString *text = title;
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font, NSParagraphStyleAttributeName:parstyle }];
        CGFloat maxWidth = MIN(size.width, self.frame.size.width-50*2);
        
        _titleLabel.frame = CGRectMake((self.frame.size.width-maxWidth)/2, (height-44), maxWidth, 44);
        [_titleLabel setText:title];
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


@end








