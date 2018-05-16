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
{
    BOOL _autoLayout;                       //自动布局

}
@property (nonatomic, weak)SSClassifyView *contentView;
@end

@implementation SSClassifyView


#pragma mark - 改造
-(instancetype)init{
    if(self = [super init]) {
        _autoLayout = YES;
    }
    return self;
}

// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _visableItemCount = 5;
        _rowHeight = 65;
        _rowSpace = 0;
        _titleFont = SSFontWithName(@"", 10);
        _imageSize = CGSizeMake(44, 44);
        _titleColor = SSColorWithRGB(51, 51, 51, 1);
        //        _imageCornerRadius = _imageSize.width/2;
    }
    return self;
}


//搭建内容视图
- (void)initContentView{
    NSArray *titles = nil;
    NSArray<NSURL *> *imageUrls = nil;
    NSArray<UIImage *> *images = nil;
    //名称
    if ([_dataSource respondsToSelector:@selector(classifyTitles)]) {
        titles = [_dataSource classifyTitles];
    }
    // 图像
    if ([_dataSource respondsToSelector:@selector(classifyImages)]) {
        images = [_dataSource classifyImages];
    }
    // 一组图片地址
    if ([_dataSource respondsToSelector:@selector(classifyImageUrls)]) {
        imageUrls = [_dataSource classifyImageUrls];
    }
    // 加载
    [self _initContentViewWithTitles:titles
                           imageUrls:imageUrls
                              images:images];
}



#pragma mark - 本地方法
//初始化内容视图
- (void)_initContentViewWithTitles:(NSArray *)titles
                         imageUrls:(NSArray<NSURL *> *)urls
                            images:(NSArray<UIImage *> *)images
{
    //默认一行最多数量
    __weak AMDButton *_firstBt = nil;
    __weak AMDButton *_lastBt = nil;
    __block AMDButton *_upBt = nil;
    
    NSInteger row = 0;// i/count;
    NSInteger column = 0;  //i%count;
    
    for (int i = 0; i < MAX(urls.count, images.count); i++) {
        //垂直方向 行数固定 列数自适应
        //行
        row = i/_visableItemCount;
        //列
        column = i%_visableItemCount;
        //分类anniu
        NSURL *imageurl = urls[i];
        AMDButton *bt = [[AMDButton alloc]init];
        bt.tag = i;
        [bt setImageWithUrl:imageurl placeHolder:nil];
        bt.imageView.image = images[i];
        bt.titleLabel.text = titles[i];
        bt.titleLabel.textColor = _titleColor;
        bt.titleLabel.font = _titleFont;
        [bt addTarget:self action:@selector(clickClassifyAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        if (titles.count == 0) {
            [bt.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.right.offset(0);
            }];
        }else{
            bt.imageView.layer.cornerRadius = _imageCornerRadius;
            bt.imageView.layer.masksToBounds = YES;
            [bt.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(bt.mas_centerX);
                make.top.offset(0);
                make.width.offset(self->_imageSize.width);
                make.height.offset(self->_imageSize.height);
            }];
            [bt.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.offset(0);
                make.height.offset(15);
            }];
        }
        
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self->_rowHeight));
            // 第一个按钮不存在的时候
            if (_firstBt == nil) {
                make.top.equalTo(@0);
                make.left.equalTo(@(self->_rowSpace));
            }
            else {
                // 设置等宽度
                make.width.equalTo(_lastBt.mas_width);
                
                // 第一行
                if (row == 0) {
                    make.top.equalTo(_firstBt.mas_top);
                }else {  //其余行的时候
                    make.top.equalTo(_upBt.mas_bottom).with.offset(self->_rowSpace);
                }
                
                // 首列
                if (column == 0) {
                    make.left.equalTo(@(self->_rowSpace));
                }else {// 设置左侧约束
                    make.left.equalTo(_lastBt.mas_right).with.offset(self->_rowSpace);
                    // 末列
                    if (column == self->_visableItemCount-1) {
                        make.right.offset(-self->_rowSpace).priorityHigh();
                    }
                }
            }
            if (column == self->_visableItemCount-1) {
                _upBt = bt;
            }
        }];
        
        _lastBt = bt;
        if (i == 0)  _firstBt = bt;
    }
    
    // 修正当配置数量少于一行的时候
    if (urls.count < _visableItemCount) {
        [_lastBt mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-self->_rowSpace));
        }];
    }
    
    // 更新一下高度
    if (_autoLayout) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self->_rowHeight*(row+1)+self->_rowSpace*(row)));
        }];
    }else{
        self.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, _rowHeight*(row+1)+_rowSpace*(row));
    }
}


#pragma mark - 点击事件
- (void)clickClassifyAction:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(classiftView:didSelectAtIndex:)]) {
        [_delegate classiftView:self didSelectAtIndex:sender.tag];
    }
}



#pragma mark - Public-Api
//预加载
- (void)prepareForLoad
{
    [self initContentView];
}


- (void)reload
{
    //移除所有子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //重新加载
    [self prepareForLoad];
}


@end




