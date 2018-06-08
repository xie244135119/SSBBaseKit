//
//  AMDRootTableController.h
//  SSBaseKit
//  一个tableview
//  Created by SunSet on 2018/6/5.
//  Copyright © 2018年 SunSet. All rights reserved.
//

#import "AMDRootViewController.h"
#import <UIKit/UIKit.h>

@interface AMDRootTableController : AMDRootViewController

// 表格
@property(nonatomic, weak) UITableView *tableView;
// 数据源
@property(nonatomic, strong) NSMutableArray *sourceArry;
// 支持下拉刷新
@property(nonatomic) BOOL downRefresh;
// 支持加载更多
@property(nonatomic) BOOL upLoadMore;


// 下拉刷新
- (void)pullingTableViewDidStartRefreshing:(UITableView *)tableView;
// 加载更多
- (void)pullingTableViewDidStartLoading:(UITableView *)tableView;


@end





