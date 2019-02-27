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
 搜索框提示文字
 */
@property (nonatomic, copy)NSString *placeholder;

/**
 搜索框
 */
@property (nonatomic, strong)UITextField *textField;

/**
 支持取消按钮
 */
@property (nonatomic)BOOL showCancel;

/**
 点击取消触发事件
 */
@property (nonatomic, copy)void(^clickCancelCompletion)(void);

/**
 试图渲染
 */
- (void)prepareView;

@end

NS_ASSUME_NONNULL_END
