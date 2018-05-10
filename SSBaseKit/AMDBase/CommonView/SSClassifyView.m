//
//  SSClassifyView.m
//  SSClassifyViewDemo
//
//  Created by 马清霞 on 2018/4/12.
//  Copyright © 2018年 Sherry. All rights reserved.
//

#import "SSClassifyView.h"
#import <Masonry/Masonry.h>
#import "AMDButton.h"
#import "SSGlobalVar.h"

@interface SSClassifyView()
@property (nonatomic, weak)SSClassifyView *contentView;
@end

@implementation SSClassifyView


#pragma mark - 本地方法
//初始化内容视图
- (void)_initContentViewWithTitles:(NSArray *)titles imageUrls:(NSArray *)urls;
{
    //默认一行最多数量
    __weak AMDButton *_firstBt = nil;
    __weak AMDButton *_lastBt = nil;
    __block AMDButton *_upBt = nil;

    NSInteger row = 0;// i/count;
    NSInteger column = 0;  //i%count;
    CGFloat itemWidth = (SScreenWidth-((_visableItemCount+1)*10))/_visableItemCount+10;//每个item宽度
    //底部滑动视图
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    //如果是水平
    if (_direcrion == SSClassifyHorizontal) {
        scrollview.contentSize = CGSizeMake((urls.count+1)*itemWidth, 0);
    }else{
        scrollview.contentSize = CGSizeMake(0, (column+1)*_rowHeight-_rowHeight);
    }
    [self addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *contentView = nil;
    if (_direcrion == SSClassifyVertical) {
        contentView = [[UIView alloc] init];
        [scrollview addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.offset(0);
            make.width.equalTo(scrollview);
            make.bottom.equalTo(scrollview);
        }];
    }
    
        for (int i = 0; i < urls.count; i++) {
            //如果是水平方向 列数固定 行数自适应
            if (_direcrion == SSClassifyHorizontal) {
                //行
                row = 0;
                //列
                column = i%urls.count;
            }else{
                //垂直方向 行数固定 列数自适应
                //行
                row = i/_visableItemCount;
                //列
                column = i%_visableItemCount;
            }
            //分类anniu
            NSURL *imageurl = urls[i];
            AMDButton *bt = [[AMDButton alloc]init];
            bt.layer.borderWidth = 1;
            [bt setImageWithUrl:imageurl placeHolder:nil];
            bt.titleLabel.text = titles[i];
            bt.titleLabel.textColor = SSColorWithRGB(51, 51, 51, 1);
            bt.titleLabel.font = SSFontWithName(@"", 10);
            [bt addTarget:self action:@selector(clickClassifyAction:) forControlEvents:UIControlEventTouchUpInside];
            if (contentView) {
                [contentView addSubview:bt];
            }else{
                [scrollview addSubview:bt];
            }
            if (titles.count == 0) {
                [bt.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.bottom.right.offset(0);
                }];
            }else{
                bt.imageView.layer.cornerRadius = 22;
                bt.imageView.layer.masksToBounds = YES;
                [bt.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(bt.mas_centerX);
                    make.top.offset(0);
                    make.width.offset(_imageSize.width);
                    make.height.offset(_imageSize.height);
                }];
                [bt.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.offset(0);
                    make.height.offset(15);
                }];
            }

            [bt mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(_rowHeight));
                // 第一个按钮不存在的时候
                if (_firstBt == nil) {
                    make.top.equalTo(@0);
                    make.left.equalTo(@10);
                    if (_direcrion == SSClassifyHorizontal) {
                        // 设置等宽度
                        make.width.equalTo(@(itemWidth));
                    }
                }
                else {
                    if (_direcrion == SSClassifyHorizontal) {
                        // 设置等宽度
                        make.width.equalTo(@(itemWidth));
                    }else{
                        // 设置等宽度
                        make.width.equalTo(_lastBt.mas_width);
                    }
                    
                    // 第一行
                    if (row == 0) {
                        make.top.equalTo(_firstBt.mas_top);
                    }else {  //其余行的时候
                        make.top.equalTo(_upBt.mas_bottom).with.offset(10);
                    }

                    // 首列
                    if (column == 0) {
                        make.left.equalTo(@10);
                    }else {// 设置左侧约束
                        make.left.equalTo(_lastBt.mas_right).with.offset(10);
                        if (_direcrion != SSClassifyHorizontal) {
                            // 末列
                            if (column == _visableItemCount-1) {
                                make.right.offset(-10).priorityHigh();
                            }
                        }
                    }
                }
                if (column == _visableItemCount-1) {
                    _upBt = bt;
                }
            }];
            
            _lastBt = bt;
            if (i == 0)  _firstBt = bt;
        }
        
        // 修正当配置数量少于一行的时候
        if (urls.count < _visableItemCount) {
            [_lastBt mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(@-10);
            }];
        }
    
    // 更新一下高度
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_rowHeight*(row+1)+_rowSpace*(row)));
    }];
}


#pragma mark - 点击事件
- (void)clickClassifyAction:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(classiftView:didSelectAtIndex:)]) {
        [_delegate classiftView:self didSelectAtIndex:sender.tag];
    }
}


#pragma mark - 改造
// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _visableItemCount = 5;
        _rowHeight = 65;
        _rowSpace = 10;
        _imageSize = CGSizeMake(44, 44);
        _titleFont = [UIFont systemFontOfSize:11];;
        _titleColor = SSColorWithRGB(51, 51, 51, 1);
    }
    return self;
}


//预加载
- (void)prepareForLoad{
    [self initContentView];
}


//搭建内容视图
- (void)initContentView{
    NSArray *titles = nil;
    NSArray *imageUrls = nil;
    //名称
    if ([_dataSource respondsToSelector:@selector(classifyTitles)]) {
        titles = [_dataSource classifyTitles];
    }
    //图片
    if ([_dataSource respondsToSelector:@selector(classifyImageUrls)]) {
            imageUrls = [_dataSource classifyImageUrls];
    }
    [self _initContentViewWithTitles:titles imageUrls:imageUrls];
}


- (void)reload{
    
}


@end







