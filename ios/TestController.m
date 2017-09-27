//
//  TestController.m
//  ios
//
//  Created by SunSet on 2017/9/27.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import "TestController.h"

@implementation TestController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitle:@"测试" forState:UIControlStateNormal];
    [bt setFrame:CGRectMake(0, 0, 50, 40)];
    bt.layer.borderWidth = 1;
    [self.contentView addSubview:bt];
}


@end
