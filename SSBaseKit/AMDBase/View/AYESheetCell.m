//
//  AYESheetCell.m
//  AppMicroDistribution
//
//  Created by leo on 16/4/1.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "AYESheetCell.h"
#import "SSGlobalVar.h"

@implementation AYESheetCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.contentView.backgroundColor = selected ? SSLineColor : [UIColor whiteColor];
                         }];
    } else {
        self.contentView.backgroundColor = selected ? SSLineColor : [UIColor whiteColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.contentView.backgroundColor = highlighted ? SSLineColor : [UIColor whiteColor];
                         }];
    } else {
        self.contentView.backgroundColor = highlighted ? SSLineColor : [UIColor whiteColor];
    }
}

@end
