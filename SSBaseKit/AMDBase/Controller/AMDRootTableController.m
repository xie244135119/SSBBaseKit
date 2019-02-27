//
//  AMDRootTableController.m
//  SSBaseKit
//
//  Created by SunSet on 2018/6/5.
//  Copyright © 2018年 SunSet. All rights reserved.
//

#import "AMDRootTableController.h"
#import <Masonry/Masonry.h>


@interface AMDRootTableController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation AMDRootTableController

- (void)dealloc
{
    self.sourceArry = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self setupViews];
    // 配置
    [self setupPreference];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 初始化视图
// 初始化视图
- (void)setupViews
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorInset = UIEdgeInsetsZero;
    [self.contentView addSubview:tableView];
    _tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
}

// 初始化配置
- (void)setupPreference
{
    // 下拉刷新
    if (_downRefresh) {
        self.downRefresh = YES;
    }
    // 加载更多
    if (_upLoadMore) {
        self.upLoadMore = YES;
    }
}


#pragma mark -
// 数据源
- (NSMutableArray *)sourceArry
{
    if (_sourceArry == nil) {
        _sourceArry = [[NSMutableArray alloc]init];
    }
    return _sourceArry;
}

// 下拉刷新
- (void)setDownRefresh:(BOOL)downRefresh
{
    if (_downRefresh != downRefresh) {
        _downRefresh = downRefresh;
        if (downRefresh) {
            [_tableView addHeaderWithTarget:self action:@selector(pullingTableViewDidStartRefreshing:)];
        }
        else {
            [_tableView removeHeader];
        }
    }
}

// 加载更多
- (void)setUpLoadMore:(BOOL)upLoadMore
{
    if (_upLoadMore != upLoadMore) {
        _upLoadMore = upLoadMore;
        if (upLoadMore) {
            [_tableView addFooterWithTarget:self action:@selector(pullingTableViewDidStartLoading:)];
        }
        else {
            [_tableView removeFooter];
        }
    }
}


#pragma mark - UITableViewDataSource
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArry.count;
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellider = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellider];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellider];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


// 选中某一个indexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Over-ride
}


#pragma mark - 下拉刷新
// 下拉刷新
- (void)pullingTableViewDidStartRefreshing:(UITableView *)tableView
{
    //
}

// 加载更多
- (void)pullingTableViewDidStartLoading:(UITableView *)tableView
{
    //
}


@end










