//
//  SSArrowView.h
//  SSBaseKit
//
//  Created by Sherry on 2018/11/5.
//  Copyright © 2018年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, SSArrowViewDirection) {
    SSArrowViewDirectionTop = 0,
    SSArrowViewDirectionBottom,
    SSArrowViewDirectionLeft,
    SSArrowViewDirectionRight
};

@interface SSArrowView : UIView


/**
 开始绘制

 @param direction 箭头方向
 */
- (void)prepareViewWithDirection:(SSArrowViewDirection)direction;

@end

NS_ASSUME_NONNULL_END
