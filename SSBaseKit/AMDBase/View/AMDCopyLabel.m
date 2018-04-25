//
//  AMDCopyLabel.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDCopyLabel.h"
//#import "AppDelegate.h"

@implementation AMDCopyLabel
{
    UIColor *_orignTextColor;               //原始的文字颜色
    UIColor *_originBackGroundColor;        //原始背景色
    UILongPressGestureRecognizer *_longPressGesture;        //长按手势
}

- (void)dealloc
{
    _longPressGesture = nil;
    _orignTextColor = nil;
    self.customCopyStr = nil;
    _originBackGroundColor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

// 可以响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(menuItemCopy:)) || (action == @selector(menuItemCollect:)) || (action == @selector(menuItemJoin:)) || (action == @selector(menuItemTransmit:));
}



//UILabel默认是不接收事件的，我们需要自己添加touch事件
- (void)attachTapHandler
{
    self.userInteractionEnabled = YES;
}

//绑定事件
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        //
        [self supportCopyFunction];
    }
    return self;
}

// 支持复制功能
- (void)supportCopyFunction
{
    if (_responderView == nil) {
        self.responderView = self;
    }
    
    self.userInteractionEnabled = YES;
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
}


#pragma mark - SET
- (void)setResponderView:(UIView *)responderView
{
    if (_responderView != responderView) {
        // 移除之前默认的长按手势
        if (_longPressGesture) {
            [_responderView removeGestureRecognizer:_longPressGesture];
        }
        
        _responderView = responderView;
    }
    
    if (responderView) {
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizer:)];
        [responderView addGestureRecognizer:press];
        _longPressGesture = press;
    }
}


#pragma mark - Public Api
// 重置
- (void)reset
{
    // 背景色
    if (_originBackGroundColor) {
        self.backgroundColor = _originBackGroundColor;
    }
    // 菜单可选
    if ([UIMenuController sharedMenuController].menuVisible) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
}

// 选中
- (void)select
{
    // 记录背景色
    if (_originBackGroundColor == nil) {
        _originBackGroundColor = self.backgroundColor;
    }
    // 选中色
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
}



#pragma mark - UITouch事件
// 点击事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 重置
    [self reset];
}



#pragma mark - 通知页面
// menuitem隐藏
- (void)menuControllerDidHide:(NSNotification *)noti
{
    [self reset];
}

//
- (void)menuControllerWillShow:(NSNotification *)noti
{
    //
}


// 长按复制
- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //
        [self becomeFirstResponder];
        //
        [self select];
        
        UIMenuItem * itemPase = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuItemCopy:)];
        UIMenuController * menuController = [UIMenuController sharedMenuController];
        [menuController setMenuItems: @[itemPase]];
        // 将当前标签的值转化为屏幕上
        CGPoint location = CGPointMake(_responderView.frame.size.width/2, 0);
        CGRect menuLocation = CGRectMake(location.x, location.y, 0, 0);
        [menuController setTargetRect:menuLocation inView:[recognizer view]];
        menuController.arrowDirection = UIMenuControllerArrowDown;
        [menuController setMenuVisible:YES animated:YES];
    }
}

// 复制
- (void)menuItemCopy:(UIMenuItem *)menuItem
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _customCopyStr?_customCopyStr:self.text;
}

// 转发
- (void)menuItemTransmit:(UIMenuItem *)menuitem
{
    NSLog(@" 转发 ");
}

// 收藏
- (void)menuItemCollect:(UIMenuItem *)menuitem
{
    NSLog(@" 收藏 ");
}

// 加入
- (void)menuItemJoin:(UIMenuItem *)menuItem
{
    NSLog(@" 加入 ");
}



#pragma mark - 自适应Api
//
- (CGSize)calculateSize
{
    return [self calculateSizeWithLineSpace:3];
}

//
- (CGSize)calculateSizeWithLineSpace:(CGFloat)lineSpace {
    CGFloat lineS = lineSpace;
    CGSize size;
    NSMutableAttributedString *attString = self.attributedText.mutableCopy;
    if (!attString && self.text.length > 0) {
        attString = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        return CGSizeZero;
    }
    if (!(lineS > 0)) {
        lineS = 3;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = lineS;
    [attString addAttribute:NSParagraphStyleAttributeName value:[style copy] range:NSMakeRange(0, attString.string.length)];
    self.attributedText = attString.copy;
    size = [self.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    size.height += 5;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    return size;
}








@end









