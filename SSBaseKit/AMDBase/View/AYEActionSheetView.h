//
//  AYEActionSheetView.h
//  AppMicroDistribution
//
//  Created by leo on 16/4/1.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AYEActionSheetView;
@protocol AYEActionSheetViewDelegate <NSObject>

@optional
- (void)AYEActionSheetView:(AYEActionSheetView *)sheetView DidTapWithTitle:(NSString *)title;

- (void)AYEActionSheetView:(AYEActionSheetView *)sheetView DidTapWithIndex:(NSInteger)index;

- (void)AYEActionSheetView:(AYEActionSheetView *)sheetView willDismissWithIndex:(NSInteger)index;

@end

@interface AYEActionSheetView : UIControl

@property (nonatomic, weak) id<AYEActionSheetViewDelegate> delegate;

- (instancetype)initWithdelegate:(id<AYEActionSheetViewDelegate>)delegate
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithdelegate:(id<AYEActionSheetViewDelegate>)delegate
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSString *)otherButtonTitles
                            args:(va_list)argList;

- (void)showInView:(UIView *)view;

@end
