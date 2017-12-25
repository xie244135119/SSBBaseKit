//
//  AMDNoDataView.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-7-2.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDNoDataView.h"
#import "AMDButton.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>
//#import "AMDTool.h"
//#import "ATAColorConfig.h"

@interface AMDNoDataView()
{
    BOOL _autoLayout;               //自动布局
    __weak AMDButton *_showBt;      //显示的文字<当前变量后期将取消>
}
@end

@implementation AMDNoDataView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = SSColorWithRGB(246, 246, 246, 1);
        if (_autoLayout) {
            [self initContentView_AutoLayout];
        }
        else {
            [self initContentView];
        }
    }
    return self;
}

- (id)init
{
    _autoLayout = YES;
    if (self = [super init]) {
        //
    }
    return self;
}

//视图加载
- (void)initContentView
{
    //无数据的时候显示 视图
    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((width-120)/2, 45+15, 120, 120)];
    [self addSubview:imgView];
    _nodataImageView = imgView;
    
    //文本内容展示
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, width, 40)];
    textLabel.font = SSFontWithName(@"", 13);
    textLabel.textColor = SSColorWithRGB(153, 153, 153, 1);
    textLabel.numberOfLines = 2;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    _titleLabel = textLabel;
    
    //按钮显示
    AMDButton *bt = [self comonButtonWithFrame:CGRectMake(75, 270, width-150, 40) title:@"去选货"];
    bt.hidden = YES;
    [self addSubview:bt];
    _showBt = bt;
    _operationBt = bt;
}

//视图加载
- (void)initContentView_AutoLayout
{
    //无数据的时候显示 视图
    UIImageView *imgView = [[UIImageView alloc]init];
    [self addSubview:imgView];
    _nodataImageView = imgView;
    __weak typeof(self) weakself = self;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@120);
        make.top.equalTo(@(45+15));
        make.centerX.equalTo(weakself.mas_centerX);
    }];
    
    //文本内容展示
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.font = SSFontWithName(@"", 13);
    textLabel.textColor = SSColorWithRGB(153, 153, 153, 1);
    textLabel.numberOfLines = 2;
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    _titleLabel = textLabel;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(imgView.mas_bottom).with.offset(20);
        make.height.equalTo(@40);
    }];
    
    //按钮显示
    AMDButton *bt = [self comonButtonWithFrame:CGRectZero title:@"去选货"];
    bt.hidden = YES;
    [self addSubview:bt];//(75, 270, width-150, 40)
    _showBt = bt;
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@75);
        make.top.equalTo(@270);
        make.right.equalTo(@-75);
        make.height.equalTo(@40);
    }];
}


//公用的按钮
- (AMDButton *)comonButtonWithFrame:(CGRect)frame title:(NSString *)title
{
    AMDButton *bt = [[AMDButton alloc]initWithFrame:frame];
    if (_autoLayout) {
        bt = [[AMDButton alloc]init];
    }
    bt.titleLabel.text = title;
    [bt setBackgroundColor:SSColorWithRGB(68,129,235, 1) forState:UIControlStateNormal];
    [bt setBackgroundColor:nil forState:UIControlStateHighlighted];
    [bt setTitleColor:SSColorWithRGB(255, 255, 255, 1) forState:UIControlStateNormal];
    bt.titleLabel.font = SSFontWithName(@"", 15);
    bt.layer.cornerRadius = SSCornerRadius;
    bt.layer.masksToBounds = YES;
    [bt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    return bt;
}


#pragma mark - 按钮事件
- (void)clickAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(noDataView:senderIndex:)]) {
        [_delegate noDataView:self senderIndex:sender.tag];
    }
}


@end















