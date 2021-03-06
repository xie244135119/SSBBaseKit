//
//  CustomTableView.m
//  TradeApp
//
//  Created by SunSet on 14-5-23.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "CustomTableView.h"

#import "GeneralTableView.h"
#import "AMDMJRefresh.h"

@implementation CustomTableView

@synthesize sourceData = _sourceData;
@synthesize delegate = _delegate;
@synthesize tableView = _tableView;

-(void)dealloc
{
    self.sourceData = nil;
    self.delegate = nil;
    
}

+(instancetype)tableViewWithFrame:(CGRect)frame Type:(CustomTableViewType)type
{
    return [[[self class] alloc]initWithFrame:frame Type:type];
}

- (instancetype)initWithFrame:(CGRect)frame Type:(CustomTableViewType)type
{
    switch (type) {
        case kCustomTableViewTypeGeneral:
            return [[GeneralTableView alloc]initWithFrame:frame TableViewType:UITableViewStylePlain];
            break;
        case kCustomTableViewTypeGroup:
            return [[GeneralTableView_SectionNoTitle alloc]initWithFrame:frame TableViewType:UITableViewStyleGrouped];
            break;
        case kCustomTableViewTypeGeneralPlain:
            return [[GeneralTableView_Section alloc]initWithFrame:frame TableViewType:UITableViewStylePlain];
            break;
        case kCustomTableViewTypeGroupPlain:
            return [[GeneralTableView_Section alloc] initWithFrame:frame TableViewType:UITableViewStyleGrouped];
            break;
        case kCustomTableViewTypeIndex:
            return [[GeneralTableView_IndexTitle alloc]initWithFrame:frame TableViewType:UITableViewStylePlain];
            break;
        case kCustomTableViewTypeWeChatRefresh:
            return [[GeneralTableView_WeChat alloc]initWithFrame:frame TableViewType:UITableViewStylePlain];
            break;
        default:
            break;
    }
    return [self initWithFrame:frame];
}

- (instancetype)initWithType:(CustomTableViewType)type
{
    switch (type) {
        case kCustomTableViewTypeGeneral:
            return [[GeneralTableView alloc]initWithTableViewType:UITableViewStylePlain];
            break;
        case kCustomTableViewTypeGroup:
            return [[GeneralTableView_SectionNoTitle alloc]initWithTableViewType:UITableViewStyleGrouped];
            break;
        case kCustomTableViewTypeGeneralPlain:
            return [[GeneralTableView_Section alloc]initWithTableViewType:UITableViewStylePlain];
            break;
        case kCustomTableViewTypeGroupPlain:
            return [[GeneralTableView_Section alloc] initWithTableViewType:UITableViewStyleGrouped];
            break;
        case kCustomTableViewTypeIndex:
            return [[GeneralTableView_IndexTitle alloc]initWithTableViewType:UITableViewStylePlain];
            break;
        case kCustomTableViewTypeWeChatRefresh:
            return [[GeneralTableView_WeChat alloc]initWithTableViewType:UITableViewStylePlain];
            break;
        default:
            break;
    }
    return [self init];
}



-(void)clearTableViewBottom:(UITableView *)tableView
{
    //去除表格下方的空白
//    tableView.tableFooterView = [UIView new];
}


- (void)startRefresh
{
    [self.tableView headerBeginRefreshing];
}


#pragma mark - Setter事件
-(void)setSourceData:(id)sourceData
{
    if (_sourceData != sourceData) {
        _sourceData = nil;
        _sourceData = sourceData;
    }
    [_tableView reloadData];
}

//停止刷新
- (void)headerEndRefreshing
{
    [self.tableView headerEndRefreshing];
}

- (void)footerEndRefreshing
{
    [self.tableView footerEndRefreshing];
}

#pragma mark - SET方法
- (void)setRefresh:(BOOL)refresh
{
    if (_refresh != refresh) {
        _refresh = refresh;
        
        if (refresh) {
            [self.tableView addHeaderWithTarget:self action:@selector(tableViewDidStartRefreshing:)];
        }
        else{
            [self.tableView removeHeader];
        }
    }
}


// Temp property
- (void)setLoadMore:(BOOL)loadMore
{
    if (_loadMore != loadMore) {
        _loadMore = loadMore;
        
        if (loadMore) {
            [self.tableView addFooterWithTarget:self action:@selector(tableViewDidStartLoading:)];
        }
        else{
            [self.tableView removeFooter];
        }
    }
}


- (void)setReachedTheEnd:(BOOL)reachedTheEnd
{
    if (_reachedTheEnd != reachedTheEnd) {
        _reachedTheEnd = reachedTheEnd;
        
        self.tableView.footerHidden = reachedTheEnd;
        if (!reachedTheEnd) {
            [self.tableView addFooterWithTarget:self action:@selector(tableViewDidStartLoading:)];
        }
        else{
            [self.tableView removeFooter];
        }
    }
}

#pragma mark - V2.0
// 下拉刷新
- (void)setDownRefresh:(BOOL)downRefresh
{
    if (_downRefresh != downRefresh) {
        _downRefresh = downRefresh;
        
        if (downRefresh) {
            [self.tableView addHeaderWithTarget:self action:@selector(tableViewDidStartRefreshing:)];
        }
        else{
            [self.tableView removeHeader];
        }
    }
}

// 加载更多
- (void)setUpLoadMore:(BOOL)upLoadMore
{
    if (_upLoadMore != upLoadMore) {
        _upLoadMore = upLoadMore;
        
        if (upLoadMore) {
            [self.tableView addFooterWithTarget:self action:@selector(tableViewDidStartLoading:)];
        }
        else{
            [self.tableView removeFooter];
        }
    }
}


#pragma mark - 下拉刷新和加载更多
//
- (void)tableViewDidStartRefreshing:(id)collectionView
{
    if ([_delegate respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)]) {
        [_delegate pullingTableViewDidStartRefreshing:_tableView];
    }
}

//
- (void)tableViewDidStartLoading:(id)collectionView
{
    if ([_delegate respondsToSelector:@selector(pullingTableViewDidStartLoading:)]) {
        [_delegate pullingTableViewDidStartLoading:_tableView];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}


@end














