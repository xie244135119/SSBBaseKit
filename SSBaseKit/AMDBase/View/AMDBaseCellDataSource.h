//
//  AMDBaseCellDataSource.h
//  SSBaseKit
//
//  Created by SunSet on 2018/4/20.
//  Copyright © 2018年 SunSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMDBaseCellDataSource <NSObject>

@optional
// 赋值数据
- (void)assignSourceModel:(id)model;


@end


