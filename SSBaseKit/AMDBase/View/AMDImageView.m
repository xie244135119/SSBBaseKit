//
//  AMDImageView.m
//  AppMicroDistribution
//
//  Created by SunSet on 2017/5/10.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "AMDImageView.h"

@implementation AMDImageView

- (void)setImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder
{
    [self setImageWithUrl:url placeHolder:placeHolder completion:nil];
}


- (void)setImageWithUrl:(NSURL *)url
            placeHolder:(UIImage *)placeHolder
             completion:(void (^)(UIImage *, NSError *))completion
{
    // 实现主项目实现
    self.image = placeHolder;
    self.imageUrl = url;
}


- (void)setImageWithPath:(NSString *)path
             placeHolder:(UIImage *)placeHolder
{
    // 实现主项目实现
    [self setImageWithPath:path placeHolder:placeHolder completion:nil];
    
}

- (void)setImageWithPath:(NSString *)path
             placeHolder:(UIImage *)placeHolder
              completion:(void (^)(UIImage *, NSError *))completion
{
    // 实现主项目实现
    self.image = placeHolder;
    if (path) {
        self.imageUrl = [NSURL fileURLWithPath:path];
    }
}



@end




