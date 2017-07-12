//
//  AMDSexSetView.h
//  AppMicroDistribution
//  性别设置页面
//  Created by SunSet on 15-8-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import <SSBaseKit/SSBaseKit.h>
@protocol AMDSexSetViewDelegate;

@interface AMDSexSetView : AMDBaseView

//@property(nonatomic, weak) id<AMDSexSetViewDelegate> delegate;
/* 选中某项 */
@property(nonatomic, copy) void (^selectBlock)(NSString *sexString);

/* 配置选中性别 */
- (void)assignSex:(NSString *)sexString;

// 性别设置页面显示
- (void)show;


@end



@protocol AMDSexSetViewDelegate <NSObject>

@optional
// 传值
- (void)sexSetView:(AMDSexSetView *)sexView object:(id)object;
@end













