//
//  AMDCloseControl.m
//  SSBaseKit
//
//  Created by SunSet on 2017/10/17.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "AMDCloseControl.h"
#import <Masonry/Masonry.h>

@implementation AMDCloseControl


- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        //
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:@"SSBaseKit.bundle/back-close.png"];
        [self addSubview:imgView];
        if(CGRectEqualToRect(frame, CGRectZero)){
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@24);
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY);
            }];
        }
        else {
            imgView.frame = CGRectMake((frame.size.width-24)/2, (frame.size.height-24)/2, 24, 24);
        }
    }
    return self;
}




@end
