//
//  AMDTextField.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-10-26.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDTextField.h"

@implementation AMDTextField

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _supportPaste = YES;
        _supportCut = YES;
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(paste:))
    {
        return _supportPaste;
    }
    else if (action == @selector(cut:)){
        return _supportCut;
    }
    return [super canPerformAction:action withSender:sender];
}

@end









