//
//  SSSelectItemView.m
//  SSSelectItem
//
//  Created by Sherry on 2018/8/22.
//  Copyright © 2018年 Sherry. All rights reserved.
//

#import "SSSelectItemView.h"
#import <Masonry/Masonry.h>
#import "SSSortButton.h"
#import <objc/runtime.h>
#import "CustomTableView.h"
#import "SSGlobalVar.h"


#define CurrentBeforeSender @"CurrentBeforeSender"
#define CurrentSortBeforeSender @"CurrentSortBeforeSender"


@interface SSSelectItemView()<CustomTableViewDelegate>
{
    UIView *_currentMenuView;  //综合菜单栏
    UIView *_currentMenuBackView;  //半透明灰色视图
    NSMutableArray *_sourceArray;
    CustomTableView *_currentTableView;
    //    SSSortButton *_currentBt;
    NSUInteger _currentIndex;  //记录单标列表的index
}
@end


@implementation SSSelectItemView




//开始渲染
- (void)prepareView{
    if(_maxCount>_titles.count){
        [self initScrollContentView];
    }else{
        [self initContentView];
    }
}


- (void)initContentView{
    _sourceArray = [[NSMutableArray alloc] init];
    
    //按钮
    __weak SSSortButton *lastView = nil;
    for (NSInteger i =0 ;i<_titles.count; i++) {
        SSSortButton *bt = [[SSSortButton alloc]init];
        bt.arrowSelectColor =_arrowSelectColor;
        bt.arrowColor = _arrowColor;
        bt.titleLabel.text = _titles[i];
        bt.titleLabel.textColor = _titleColor;
        bt.titleLabel.font = _titleFont;
        bt.tag = i;
        if(i == 0){
            objc_setAssociatedObject(self, (__bridge const void *_Nonnull)(CurrentBeforeSender), bt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            bt.titleLabel.textColor = _titleSelectedColor;
        }
        
        [bt addTarget:self action:@selector(choiceActionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self).with.offset(0);
            // 不是第一个
            if (lastView) {
                make.left.equalTo(lastView.mas_right).with.offset(0);
                make.width.equalTo(lastView);
            }
            else {
                make.left.equalTo(self).with.offset(0);
            }
        }];
        
        //展示分割线
        if (_showDividingLine) {
            if (i != _titles.count-1){
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = _dividingLineColor?_dividingLineColor:SSLineColor;
                [bt addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(0);
                    make.centerY.equalTo(bt.mas_centerY);
                    make.width.offset(SSLineHeight);
                    make.height.offset(self->_dividingLineHeight>0?self->_dividingLineHeight:15);
                }];
            }
        }
        
        lastView = bt;
        //是否支持升降序
        for (NSNumber *index in _sortIndexs) {
            if (index.integerValue == i) {
                bt.sort = YES;
                if (!_currentMenuView) {
                    [self menuView];
                }
            }
        }
        
        //是否支持单标排序
        for (NSDictionary *dic in _aloneSortIndexs){
            NSNumber *index = dic[@"index"];
            if (index.integerValue == i) {
                bt.aloneSort = YES;
                //解除之前绑定的target
                [bt removeTarget:self
                          action:@selector(choiceActionButton:)
                forControlEvents:UIControlEventTouchUpInside];
                //重新绑定target
                [bt addTarget:self
                       action:@selector(choiceAloneActionButton:)
             forControlEvents:UIControlEventTouchUpInside];
                if (i == 0) {
                    bt.status = 2;
                }
            }
        }
    }
    // 最后一个处理按钮
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self).with.offset(0);
        make.right.equalTo(self);
    }];
    
    //展示阴影
    if (_showShadow) {
        //阴影
        self.layer.shadowOpacity = 0.08;
        self.layer.shadowOffset = CGSizeMake(0, 3);
    }
}


- (void)initScrollContentView{
    //滑动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.canCancelContentTouches = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor greenColor];
    [self addSubview:scrollView];
    //每个item的宽度
    CGFloat itemWith = self.frame.size.width/_maxCount;
    scrollView.contentSize = CGSizeMake(itemWith*_titles.count,self.frame.size.height);
    
    //背景视图
    UIView *contentBack = [[UIView alloc] init];
    [scrollView addSubview:contentBack];
    [contentBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(itemWith*self->_titles.count);
        make.height.offset(self.frame.size.height);
    }];
    
    //按钮
    __weak SSSortButton *lastView = nil;
    for (NSInteger i =0 ;i<_titles.count; i++) {
        SSSortButton *bt = [[SSSortButton alloc]init];
        bt.arrowColor = _arrowColor;
        bt.titleLabel.text = _titles[i];
        bt.titleLabel.textColor = _titleColor;
        bt.titleLabel.font =_titleFont;
        bt.tag = i;
        if(i == 0){
            objc_setAssociatedObject(self, (__bridge const void *_Nonnull)(CurrentBeforeSender), bt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            bt.titleLabel.textColor = _titleSelectedColor;
        }
        [bt addTarget:self action:@selector(choiceActionButton:) forControlEvents:UIControlEventTouchUpInside];
        [contentBack addSubview:bt];
        [bt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(contentBack).with.offset(0);
            make.width.offset(itemWith);
            // 不是第一个
            if (lastView) {
                make.left.equalTo(lastView.mas_right).with.offset(0);
            }
            else {
                make.left.equalTo(contentBack).with.offset(0);
            }
        }];
        
        lastView = bt;
        //是否支持升降序
        for (NSNumber *index in _sortIndexs) {
            if (index.integerValue == i) {
                bt.sort = YES;
            }
        }
    }
}


#pragma mark - 点击事件
//单标点击事件
- (void)choiceAloneActionButton:(SSSortButton *)sender{
    
    objc_setAssociatedObject(self, (__bridge const void *_Nonnull)(CurrentSortBeforeSender), sender, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //获取上一个按钮
    SSSortButton *beforeLB = objc_getAssociatedObject(self,  (__bridge const void *_Nonnull)(CurrentBeforeSender));
    
    NSDictionary *dic = _aloneSortIndexs[sender.tag];
    [_sourceArray removeAllObjects];
    [_sourceArray addObjectsFromArray:dic[@"items"]];
    if (sender.selected == NO) {
        //改变选中状态
        sender.selected = YES;
        
        //刷新列表数据
        [_currentTableView.tableView reloadData];
        [self show];
        
        if (beforeLB!=sender) {
            sender.status = -1;
        }else{
            sender.status = 1;
        }
    }else{
        if (beforeLB!=sender) {
            sender.status = 0;
        }else{
            sender.status = 1;
        }
        [self hidden];
        sender.selected = NO;
    }
}

//双标点击事件
- (void)choiceActionButton:(SSSortButton *)sender{
    //更新单标按钮
    SSSortButton *beforeSortLB = objc_getAssociatedObject(self,  (__bridge const void *_Nonnull)(CurrentSortBeforeSender));
    if (beforeSortLB) {
        beforeSortLB.status = 0;
        beforeSortLB.selected = NO;
        beforeSortLB.titleLabel.textColor = _titleColor;
        //隐藏单标按钮视图
        [self hidden];
        //更换综合标题
        NSDictionary *dic = _aloneSortIndexs[beforeSortLB.tag?beforeSortLB.tag:0];
        NSArray *items = dic[@"items"];
        _currentIndex = 0;
        beforeSortLB.titleLabel.text = items[_currentIndex];
    }
    
    //获取之前的label
    SSSortButton *beforeLB = objc_getAssociatedObject(self,  (__bridge const void *_Nonnull)(CurrentBeforeSender));
    if (beforeLB) {
        if (sender != beforeLB) {
            beforeLB.titleLabel.textColor = _titleColor;
            beforeLB.status = 0;
            _currentIndex = 0;
        }
    }
    
    //存储当前label
    objc_setAssociatedObject(self, (__bridge const void *_Nonnull)(CurrentBeforeSender), sender, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    sender.titleLabel.textColor = _titleSelectedColor;
    
    if (sender.sort) {
        if (sender.status == 0 || sender.status == 2) {
            sender.status = 1;
        }else{
            sender.status = 2;
        }
    }
    
    if (_completion) {
        _completion(sender.tag,sender.status);
    }
}


//综合下的菜单栏
- (void)menuView{
    //菜单背景图
    UIView *menuBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _senderView.frame.size.width, _senderView.frame.size.height)];
    _currentMenuView = menuBackView;
    menuBackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    //    menuBackView.backgroundColor = [UIColor redColor];
    [_senderView addSubview:menuBackView];
    [menuBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.mas_bottom);
    }];
    menuBackView.hidden = YES;
    
    //菜单栏
    CustomTableView *tableView = [[CustomTableView alloc] initWithType:kCustomTableViewTypeGeneral];
    _currentTableView = tableView;
    tableView.delegate = self;
    [menuBackView addSubview:tableView];
    tableView.sourceData = _sourceArray;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(0);
    }];
}


#pragma mark - CustomTableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView CellAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = SSLineColor;
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.bottom.offset(0);
            make.height.offset(SSLineHeight);
        }];
    }
    //改变选中色
    if (_currentIndex == indexPath.row) {
        cell.textLabel.textColor = _titleSelectedColor;
    }else{
        cell.textLabel.textColor = _titleColor;
    }
    cell.textLabel.text = _sourceArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

// 选中某一行执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SSSortButton *sortLB = objc_getAssociatedObject(self,  (__bridge const void *_Nonnull)(CurrentSortBeforeSender));
    
    //获取之前的label
    SSSortButton *beforeLB = objc_getAssociatedObject(self,  (__bridge const void *_Nonnull)(CurrentBeforeSender));
    if (beforeLB) {
        if (sortLB != beforeLB) {
            beforeLB.titleLabel.textColor = _titleColor;
            beforeLB.status = 0;
        }
    }
    
    //存储当前label
    objc_setAssociatedObject(self, (__bridge const void *_Nonnull)(CurrentBeforeSender), sortLB, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    sortLB.titleLabel.textColor = _titleSelectedColor;
    sortLB.status = 2;
    
    //更换综合标题
    NSDictionary *dic = _aloneSortIndexs[sortLB.tag];
    NSArray *items = dic[@"items"];
    sortLB.titleLabel.text = items[indexPath.row];
    
    //隐藏动画
    sortLB.selected = NO;
    [self hidden];
    
    NSNumber *index = dic[@"index"];
    _currentIndex = indexPath.row;
    //返回值
    if(_aloneCompletion){
        _aloneCompletion(index.integerValue,indexPath.row);
    }
}


#pragma mark - 动画
- (void)show{
    [_senderView bringSubviewToFront:_currentMenuView];
    _currentMenuView.hidden = NO;
    [UIView animateWithDuration:.25 animations:^{
        self->_currentMenuView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
        [self->_currentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(self->_sourceArray.count*40);
        }];
        [self->_senderView layoutIfNeeded];
    }];
}

- (void)hidden{
    [UIView animateWithDuration:.25 animations:^{
        self->_currentMenuView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self->_currentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self->_senderView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self->_currentMenuView.hidden = YES;
    }];
}

@end
