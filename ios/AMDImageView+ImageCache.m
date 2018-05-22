//
//  AMDImageView+ImageCache.m
//  AppMicroDistribution
//
//  Created by SunSet on 2017/6/20.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "AMDImageView+ImageCache.h"
#import <objc/runtime.h>
//#import <SDWebImage/>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation AMDImageView (ImageCache)

// 改变两者之间实现
+ (void)exchangeSel:(SEL)originSel senderSel:(SEL)senderSel
{
    Method orignMethod = class_getInstanceMethod([self class], originSel);
    Method senderMethod = class_getInstanceMethod([self class], senderSel);
    method_exchangeImplementations(orignMethod, senderMethod);
}


+ (void)load
{
    [self exchangeSel:@selector(setImageWithUrl:placeHolder:) senderSel:@selector(amd_setImageWithUrl:placeHolder:)];
//    [self exchangeSel:@selector(downloadImageWithUrl:completion:) senderSel:@selector(amd_downloadImageWithUrl:completion:)];
}

- (void)amd_setImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder
{
    [self sd_setImageWithURL:url placeholderImage:placeHolder];
//    [self sd_internalSetImageWithURL:url
//                    placeholderImage:placeHolder
//                             options:0
//                        operationKey:nil
//                       setImageBlock:nil
//                            progress:nil
//                           completed:nil];
//    NSLog(@" 图片加载 目前注释掉 ");
}

- (void)amd_downloadImageWithUrl:(NSURL *)url
                      completion:(void (^)(UIImage *, NSError *))completion
{
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:nil completed:nil];
}



@end





