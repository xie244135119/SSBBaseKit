//
//  SSSortButton.m
//  SSSelectItem
//
//  Created by Sherry on 2018/8/22.
//  Copyright © 2018年 Sherry. All rights reserved.
//

#import "SSSortButton.h"
#import <Masonry/Masonry.h>
#import "SSArrowView.h"


#define SSWidth self.frame.size.width
#define SSHeight self.frame.size.height


@interface SSSortButton()
{
    SSArrowView *_topArrow;
    SSArrowView *_bottomArrow;
}
@end

@implementation SSSortButton

#pragma mark - 初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initContentView];
    }
    return self;
}


#pragma mark - 视图搭建
- (void)initContentView{
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.bottom.offset(0);
    }];
}


- (void)initSortView{
    //上图标
    SSArrowView *topArrow = [[SSArrowView alloc] initWithFrame:CGRectMake(0, 0, 8, 4)];
//    topArrow.layer.borderWidth = 1;
    _topArrow = topArrow;
    topArrow.backgroundColor = _arrowColor;
    [self addSubview:topArrow];
    [topArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_titleLabel.mas_right);
        make.centerY.equalTo(self ->_titleLabel.mas_centerY).offset(-2.5);
        make.width.offset(8);
        make.height.offset(4);
    }];
    [topArrow prepareViewWithDirection:SSArrowViewDirectionTop];
    
    
    //下图标
    SSArrowView *bottomArrow = [[SSArrowView alloc] initWithFrame:CGRectMake(0, 0, 8, 4)];
    _bottomArrow = bottomArrow;
    bottomArrow.backgroundColor = _arrowColor;
    [self addSubview:bottomArrow];
    [bottomArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_titleLabel.mas_right);
        make.centerY.equalTo(self->_titleLabel.mas_centerY).offset(2.5);
        make.width.offset(8);
        make.height.offset(4);
    }];
    [bottomArrow prepareViewWithDirection:SSArrowViewDirectionBottom];
}


#pragma mark - 配置状态
-(void)setSort:(BOOL)sort{
    _sort = sort;
    if (sort) {
        [self initSortView];
    }
}


- (void)setStatus:(NSUInteger)status{
    _status = status;
    switch (status) {
        case 1://升序
        {
            _topArrow.backgroundColor = _arrowSelectColor;
            _bottomArrow.backgroundColor = _arrowColor;
//            _topImageView.image = [UIImage imageNamed:@"arrow_top_select"];
//            _bottomImageView.image = [UIImage imageNamed:@"arrow_bottom_normal"];
        }
            break;
        case 2://降序
        {
            _topArrow.backgroundColor = _arrowColor;
            _bottomArrow.backgroundColor = _arrowSelectColor;
//            _topImageView.image = [UIImage imageNamed:@"arrow_top_normal"];
//            _bottomImageView.image = [UIImage imageNamed:@"arrow_bottom_select"];
        }
            break;
            
        default://默认无序
        {
            _topArrow.backgroundColor = _arrowColor;
            _bottomArrow.backgroundColor = _arrowColor;
//            _topImageView.image = [UIImage imageNamed:@"arrow_top_normal"];
//            _bottomImageView.image = [UIImage imageNamed:@"arrow_bottom_normal"];
        }
            break;
    }
}

@end














