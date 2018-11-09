//
//  SSTextField.m
//  SSBaseKit
//
//  Created by Sherry on 2018/11/9.
//  Copyright © 2018年 SunSet. All rights reserved.
//

#import "SSTextField.h"
#import <Masonry/Masonry.h>
#import "SSGlobalVar.h"


#define SSColorWithRGB(r,g,b,a) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:a]


@interface SSTextField()
{
    UIButton *_cancelBt;  //取消按钮
    BOOL _showCancel;
}
@end


@implementation SSTextField



- (instancetype)init{
    if (self = [super init]) {
        [self initContentView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initContentView];
    }
    return self;
}


- (void)initContentView{
    //搜索框
    UITextField *searchBar = [[UITextField alloc] init];
    _textField = searchBar;
    searchBar.layer.cornerRadius = 15.0f;//设置圆角具体根据实际情况来设置
    searchBar.textColor = SSColorWithRGB(119, 119, 119, 1);
    searchBar.font = [UIFont systemFontOfSize:14];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [searchBar setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    searchBar.font = [UIFont systemFontOfSize:14];
    [self addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    //放大镜图标
    UIView *textFieldLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *imageViewPwd=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    imageViewPwd.image=SSImageFromName(@"search");
    [textFieldLeftView addSubview:imageViewPwd];
    searchBar.leftView=textFieldLeftView;
    searchBar.leftViewMode=UITextFieldViewModeAlways;
    
    //取消按钮
    UIButton *bt = [[UIButton alloc] init];
    _cancelBt = bt;
//    bt.layer.borderWidth = 1;
    bt.hidden = YES;
    [bt setTitle:@"取消" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    bt.titleLabel.font = [UIFont systemFontOfSize:15];
    [bt setTitleColor:SSColorWithRGB(51, 51, 51, 1) forState:UIControlStateNormal];
    [self addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchBar.mas_centerY);
        make.left.equalTo(searchBar.mas_right).offset(10);
        make.height.offset(30);
    }];
}


#pragma mark - 赋值
- (void)showCancel:(BOOL)showCancel
           animate:(BOOL)animate{
    _showCancel = showCancel;
    if (showCancel) {
        if (animate) {
            [UIView animateWithDuration:.25 animations:^{
                [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (_adaptation) {
                        make.right.offset(-40);
                    }else
                    make.right.offset(-55);
                }];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                _cancelBt.hidden = NO;
            }];
        }else{
            [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
                if (_adaptation) {
                    make.right.offset(-40);
                }else
                    make.right.offset(-55);
            }];
            _cancelBt.hidden = NO;
        }

    }else{
        if (animate) {
            [UIView animateWithDuration:.25 animations:^{
                [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(0);
                }];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                _cancelBt.hidden = YES;
            }];
        }else{
            [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
                if (_adaptation) {
                    make.right.offset(0);
                }else{
                    make.right.offset(-15);
                }
            }];
            _cancelBt.hidden = YES;
        }
    }
}

//重新渲染视图
-(void)setAdaptation:(BOOL)adaptation{
    _adaptation = adaptation;
    if (adaptation) {
        [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.offset(0);
            if (_showCancel) {
                make.right.offset(-40);
            }else{
                make.right.offset(0);
            }
        }];
    }
}

#pragma mark - 点击事件
- (void)clickCancel{
    if (_clickCancelCompletion) {
        _clickCancelCompletion();
    }
}


@end
