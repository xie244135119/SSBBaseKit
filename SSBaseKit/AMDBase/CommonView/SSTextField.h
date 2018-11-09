//
//  SSTextField.h
//  SSBaseKit
//  支持放大镜图标搜索框
//  Created by Sherry on 2018/11/9.
//  Copyright © 2018年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSTextField : UIView


/**
 自动适配frame  默认统一frame
 开启适配textField则主动适配父视图SSTextField大小
 */
@property (nonatomic)BOOL adaptation;

/**
 搜索框
 */
@property (nonatomic, weak)UITextField *textField;

/**
 是否支持取消按钮 (默认不显示)

 @param showCancel 是否展示
 @param animate 是否需要加载动画
 */
- (void)showCancel:(BOOL)showCancel
           animate:(BOOL)animate;

/**
 点击取消触发事件
 */
@property (nonatomic, copy)void(^clickCancelCompletion)(void);

@end

NS_ASSUME_NONNULL_END
