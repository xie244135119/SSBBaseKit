//
//  AMDImageCropController.h
//  AppMicroDistribution
//  图片剪裁类处理
//  Created by Fuerte on 16/7/28.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSImageCropController : UIViewController


/** * 原始图像 */
@property(nonatomic, strong) UIImage *orignImage;
// 剪裁的图像本地地址
//@property(nonatomic, copy) NSString *imagePath;

/** 剪裁比例(默认 1:1) */
@property(nonatomic) CGRect cropFrame;
/** 剪裁比例(宽高比例) 默认 1:1 */
@property(nonatomic) CGFloat cropScale;

/** * 限制最大的比例 默认2 */
@property(nonatomic, assign) CGFloat maxScale;
/** *  限制的最小比例 默认1 */
@property(nonatomic, assign) CGFloat minScale;
/**
 * V2.3 后支持的新回调模型
 * 图片剪裁之后 需要执行的事件
 * return 返回值用于是否回退页面
 */
//@property(nonatomic, copy) BOOL (^completeBlock)(NSString *imageUrl);
@property(nonatomic, copy) BOOL (^completeBlock)(UIImage *cropImage, NSError *error);



@end







