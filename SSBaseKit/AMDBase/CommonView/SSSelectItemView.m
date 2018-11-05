//
//  SSSelectItemView.m
//  SSSelectItem
//
//  Created by Sherry on 2018/8/22.
//  Copyright © 2018年 Sherry. All rights reserved.
//

#import "SSSelectItemView.h"
#import <Masonry/Masonry.h>
#import "SSSortButton.h"
#import <objc/runtime.h>


//#define SSColorWithRGB(r,g,b,a) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:a]
#define CurrentBeforeSender @"CurrentBeforeSender"


@implementation SSSelectItemView




//开始渲染
- (void)prepareView{
    if(_maxCount>_titles.count){
        [self initScrollContentView];
    }else{
        [self initContentView];
    }
}


- (void)initContentView{
    //按钮
    __weak SSSortButton *lastView = nil;
    for (NSInteger i =0 ;i<_titles.count; i++) {
        SSSortButton *bt = [[SSSortButton alloc]init];
        bt.arrowSelectColor =_arrowSelectColor;
        bt.arrowColor = _arrowColor;
        bt.titleLabel.text = _titles[i];
        bt.titleLabel.textColor = _titleColor;
        bt.titleLabel.font = _titleFont;
        bt.tag = i;
        if(i == 0){
            objc_setAssociatedObject(self, (__bridge const void *_Nonnull)(CurrentBeforeSender), bt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            bt.titleLabel.textColor = _titleSelectedColor;
        }
        [bt addTarget:self action:@selector(choiceActionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self).with.offset(0);
            // 不是第一个
            if (lastView) {
                make.left.equalTo(lastView.mas_right).with.offset(0);
                make.width.equalTo(lastView);
            }
            else {
                make.left.equalTo(self).with.offset(0);
            }
        }];
        
        lastView = bt;
        //是否支持升降序
        for (NSNumber *index in _sortIndexs) {
            if (index.integerValue == i) {
                bt.sort = YES;
            }
        }
    }
    // 最后一个处理按钮
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self).with.offset(0);
        make.right.equalTo(self);
    }];
}


- (void)initScrollContentView{
    //滑动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.canCancelContentTouches = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor greenColor];
    [self addSubview:scrollView];
    //每个item的宽度
    CGFloat itemWith = self.frame.size.width/_maxCount;
    scrollView.contentSize = CGSizeMake(itemWith*_titles.count,self.frame.size.height);

    //背景视图
    UIView *contentBack = [[UIView alloc] init];
//    contentBack.backgroundColor = [UIColor redColor];
//    contentBack.layer.borderWidth = 1;
    [scrollView addSubview:contentBack];
    [contentBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(itemWith*self->_titles.count);
        make.height.offset(self.frame.size.height);
    }];

    //按钮
    __weak SSSortButton *lastView = nil;
    for (NSInteger i =0 ;i<_titles.count; i++) {
        SSSortButton *bt = [[SSSortButton alloc]init];
        bt.arrowColor = _arrowColor;
        bt.titleLabel.text = _titles[i];
        bt.titleLabel.textColor = _titleColor;
        bt.titleLabel.font =_titleFont;
        bt.tag = i;
        if(i == 0){
            objc_setAssociatedObject(self, (__bridge const void *_Nonnull)(CurrentBeforeSender), bt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            bt.titleLabel.textColor = _titleSelectedColor;
        }
        [bt addTarget:self action:@selector(choiceActionButton:) forControlEvents:UIControlEventTouchUpInside];
        [contentBack addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(contentBack).with.offset(0);
            make.width.offset(itemWith);
            // 不是第一个
            if (lastView) {
                make.left.equalTo(lastView.mas_right).with.offset(0);
            }
            else {
                make.left.equalTo(contentBack).with.offset(0);
            }
        }];
        
        lastView = bt;
        //是否支持升降序
        for (NSNumber *index in _sortIndexs) {
            if (index.integerValue == i) {
                bt.sort = YES;
            }
        }
    }
}


#pragma mark - 点击事件
- (void)choiceActionButton:(SSSortButton *)sender{
    
    //获取之前的label
    SSSortButton *beforeLB = objc_getAssociatedObject(self,  (__bridge const void *_Nonnull)(CurrentBeforeSender));
    if (beforeLB) {
        if (sender != beforeLB) {
            beforeLB.titleLabel.textColor = _titleColor;
            beforeLB.status = 0;
        }
    }
    
    //存储当前label
    objc_setAssociatedObject(self, (__bridge const void *_Nonnull)(CurrentBeforeSender), sender, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    sender.titleLabel.textColor = _titleSelectedColor;
    
    if (sender.sort) {
        if (sender.status == 0 || sender.status == 2) {
            sender.status = 1;
        }else{
                sender.status = 2;
        }
    }
    
    if (_completion) {
        _completion(sender.tag,sender.status);
    }
    
}


@end
