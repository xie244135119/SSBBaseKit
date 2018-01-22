//
//  AYEActionSheetView.m
//  AppMicroDistribution
//
//  Created by leo on 16/4/1.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AYEActionSheetView.h"
#import "SSGlobalVar.h"
#import "AMDButton.h"
#import "AMDLineView.h"


#define kCellHeight 50
#define kBackColorAlpha 0.4
#define kSeperateLineColor SSColorWithRGB(179, 182, 191, 1)     //分割线条颜色
#define kSeperateLineSpace 6                                    //分割端高度

@interface AYEActionSheetView ()
{
    __weak UIView *_middleView;             //中间视图
}
@end

@implementation AYEActionSheetView
@synthesize barFont = _barFont;

- (instancetype)initWithdelegate:(id<AYEActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles args:(va_list)argList
{
    self = [super init];
    if (self) {
        NSMutableArray *mutableArr = [NSMutableArray array];
        {
            if (otherButtonTitles) {
                [mutableArr addObject:otherButtonTitles];
                NSString *title = nil;
                while ((title = va_arg(argList, NSString *))) {
                    [mutableArr addObject:title];
                }
            }
        }
        
        [self _loadViewWithDestructiveTitle:destructiveButtonTitle
                               actionTitles:mutableArr
                                cancelTitle:cancelButtonTitle];
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithdelegate:(id<AYEActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self) {
        NSMutableArray *mutableArr = [NSMutableArray array];
        {
            va_list titles;
            va_start(titles, otherButtonTitles);
            if (otherButtonTitles) {
                [mutableArr addObject:otherButtonTitles];
                NSString *title = nil;
                while ((title = va_arg(titles, NSString *))) {
                    [mutableArr addObject:title];
                }
            }
            va_end(titles);
        }
        [self _loadViewWithDestructiveTitle:destructiveButtonTitle
                               actionTitles:mutableArr
                                cancelTitle:cancelButtonTitle];
        _delegate = delegate;
    }
    return self;
}


#pragma mark -
// 安全区域改变的时候
- (void)safeAreaInsetsDidChange
{
    [super safeAreaInsetsDidChange];
    
    // 改变frame
    CGRect frame = self.frame;
    frame.origin.y -= self.safeAreaInsets.bottom;
    self.frame = frame;
}



#pragma mark - public api
// 显示视图
- (void)showInView:(UIView *)view
{
    if (view == nil) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    self.frame = view.frame;
    [view addSubview:self];
    
    // 动画显示
    [self _show];
}



#pragma mark - 视图重构
// 视图加载
- (void)_loadViewWithDestructiveTitle:(NSString *)destructive
                         actionTitles:(NSArray *)actionTitles
                               cancelTitle:(NSString *)cancelTitle
{
    //
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    middleView.backgroundColor = [UIColor clearColor];
    [self addSubview:middleView];
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    blurView.frame = middleView.bounds;
//    [middleView addSubview:blurView];
    _middleView = middleView;
    
    // 加重提示块
    CGFloat height = 0;
    // 创建按钮
    if (destructive) {
        // 标注按钮
        AMDButton *desbt = [self _commonButtonWithFrame:CGRectMake(0, 0, SScreenWidth, kCellHeight)];
        desbt.titleLabel.text = destructive;
        desbt.titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.3216 blue:0.2118 alpha:1.0];
        [_middleView addSubview:desbt];
        AMDLineView *line = [[AMDLineView alloc]initWithFrame:CGRectMake(0, 49.5, SScreenWidth, 0.5) Color:SSLineColor];
        [desbt addSubview:line];
        desbt.tag = -1;
        height += 50+kSeperateLineSpace;
    }
    
    // 正常的标题
    for (int i =0; i < actionTitles.count; i++) {
        AMDButton *bt = [self _commonButtonWithFrame:CGRectMake(0, height, SScreenWidth, kCellHeight)];
        bt.titleLabel.text = actionTitles[i];
        [middleView addSubview:bt];
        AMDLineView *line = [[AMDLineView alloc]initWithFrame:CGRectMake(0, 49.5, SScreenWidth, 0.5) Color:SSLineColor];
        [bt addSubview:line];
        bt.tag = i+1;
        height += 50;
    }
    
    height += kSeperateLineSpace;
    
    // 取消按钮
    if (cancelTitle) {
        // 标注按钮
        AMDButton *cancelbt = [self _commonButtonWithFrame:CGRectMake(0, height, SScreenWidth, kCellHeight)];
        [_middleView addSubview:cancelbt];
        cancelbt.titleLabel.text = @"取消";
        height += 50;
    }
    // 设置行高
    middleView.frame = CGRectMake(0, SScreenHeight, SScreenWidth, height);
}

// 公用按钮
- (AMDButton *)_commonButtonWithFrame:(CGRect)frame
{
    AMDButton *desbt = [[AMDButton alloc]initWithFrame:frame];
    [desbt setBackgroundColor:SSLineColor forState:UIControlStateHighlighted];
    [desbt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [desbt addTarget:self action:@selector(_clickAction:) forControlEvents:UIControlEventTouchUpInside];
    desbt.titleLabel.font = SSFontWithName(@"", 16);
    desbt.titleLabel.textColor = SSColorWithRGB(23, 23, 21, 0.9);

    // 线条
    AMDLineView *line = [[AMDLineView alloc]initWithFrame:CGRectMake(0, 0, SScreenWidth, 0.5) Color:SSLineColor];
    [desbt addSubview:line];
    return desbt;
}



#pragma mark - private api
// 按钮事件
- (void)_clickAction:(AMDButton *)sender
{
    NSString *title = title = sender.titleLabel.text;
    NSInteger index = sender.tag;

    if ([_delegate respondsToSelector:@selector(AYEActionSheetView:DidTapWithTitle:)]) {
        [_delegate AYEActionSheetView:self DidTapWithTitle:title];
    }
    if ([_delegate respondsToSelector:@selector(AYEActionSheetView:DidTapWithIndex:)]) {
        [_delegate AYEActionSheetView:self DidTapWithIndex:index];
    }
    if ([_delegate respondsToSelector:@selector(AYEActionSheetView:willDismissWithIndex:)]) {
        [_delegate AYEActionSheetView:self willDismissWithIndex:index];
    }
    // 隐藏视图
    [self _hide];
}

// 显示视图
- (void)_show
{
    __weak typeof(self) weakself = self;
    weakself.backgroundColor = SSColorWithRGB(0, 0, 0, 0);
    [UIView animateWithDuration:0.25 animations:^{
        _middleView.frame = CGRectMake(0, SScreenHeight-_middleView.frame.size.height, _middleView.frame.size.width, _middleView.frame.size.height);
        weakself.backgroundColor = SSColorWithRGB(0, 0, 0, kBackColorAlpha);
    }];
}

// 隐藏视图
- (void)_hide
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
        _middleView.frame = CGRectMake(0, SScreenHeight, _middleView.frame.size.width, _middleView.frame.size.height);
        weakself.backgroundColor = SSColorWithRGB(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [weakself removeFromSuperview];
    }];
}

//
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    if (CGRectContainsPoint(_middleView.frame, location)) {
        return;
    }
    //
    [self _hide];
}




@end








































