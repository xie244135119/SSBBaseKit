//
//  XQLinkageView.m
//  TestScrollView联动效果
//
//  Created by SunSet on 14-12-2.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "SSLinkageView.h"
#import "AMDImageView.h"
#import "SSGlobalVar.h"
#import <Masonry/Masonry.h>

// 重用标识符
static NSString *const kSSlinkageImageViewIder = @"kSSlinkageImageViewIder";
// 最大重复数量
static NSInteger const kSSLinkageRepeatCount = 200;


@interface SSLinkageImageView : UICollectionViewCell

@property(nonatomic, weak) AMDImageView *imageView;        //图片视图
@property(nonatomic, strong) NSURL *imageURL;      //图片名称或url地址

@end

@interface SSLinkageView() <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSTimer *_currentTimer;                                 //当前定时器

    // 集合视图
    __weak UICollectionView *_collectionView;
    // 时间  默认为0
    NSInteger _timerDuration;
    // 当前滑到到的位置
    NSInteger _currentScrollIndex;
}

@end

@implementation SSLinkageView

- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    _imageURLs = nil;
    _currentTimer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
                    imageUrls:(NSArray *)imageUrls
{
    if (self = [self initWithFrame:frame]) {
        _imageURLs = imageUrls;
    }
    return self;
}

- (instancetype)initWithImageUrls:(NSArray *)imageUrls
{
    if (self = [super init]) {
        _imageURLs = imageUrls;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        // 默认滚动时间
        _linkageDuration = 5;
        self.backgroundColor = [UIColor whiteColor];
        
        // 加载子视图
        [self setupViews];
    }
    return self;
}

//
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidate];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 滑动至
    if (_imageURLs.count > 0) {
        // 滑动
        if (_currentScrollIndex == 0 || _currentScrollIndex >= [_collectionView numberOfItemsInSection:0]) {
            _currentScrollIndex = _imageURLs.count*kSSLinkageRepeatCount*0.5;
        }
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentScrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}


#pragma mark - Public Api
//
- (void)invalidate
{
    [_currentTimer invalidate];
}

//
- (void)prepareLoad
{
    _currentPageControl.numberOfPages = _imageURLs.count;
    // 只有一页 不需要启动定时器
    if (_imageURLs.count <= 1) {
        _collectionView.scrollEnabled = NO;
        [self invalidate];
        return;
    }
    
    _collectionView.scrollEnabled = YES;
//    __weak typeof(self) weakself = self;

    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf _setupTimer];
    });
}


#pragma mark - private api
// 定时器启动
- (void)_setupTimer
{
    // 先使之前的定时器无效
    [_currentTimer invalidate];
    
    // 使之前的无效
    _currentTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(_timerChange:) userInfo:nil repeats:YES];
    //避免滑动拖拽时造成timer停止工作
    [[NSRunLoop currentRunLoop] addTimer:_currentTimer forMode:NSDefaultRunLoopMode];
}


#pragma mark - SET
- (void)setImageURLs:(NSArray<NSURL *> *)imageURLs
{
    if (_imageURLs != imageURLs) {
        _imageURLs = imageURLs;
        
        if (imageURLs) {
            [_collectionView reloadData];
        }
    }
}

//
- (void)setLinkageDuration:(NSInteger)linkageDuration
{
    if (_linkageDuration != linkageDuration) {
        _linkageDuration = linkageDuration;
        
        // 如果已存在定时器 重开
        if (_currentTimer) {
            [self invalidate];
            [self prepareLoad];
        }
    }
}


#pragma mark - 定时器处理
- (void)_timerChange:(NSTimer *)timer
{
    _timerDuration++;
    
    // 达到整点
    if (_timerDuration == _linkageDuration) {
        _timerDuration = 0;
        _currentScrollIndex += 1;
        // 滑动
        [self _scrollToIndex:_currentScrollIndex];
    }
}


// 滑动到指定位置
- (void)_scrollToIndex:(NSInteger)index
{
    // 滑动到最后一页 直接无视图切换显示会有问题
    if (index >= _imageURLs.count*kSSLinkageRepeatCount) {
        // 目前只能这么取舍了 滑动至中间 防止左右滑动失败
        _currentScrollIndex = index*0.5;
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentScrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    
    _currentScrollIndex = index;
    // 正常滑动
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentScrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

// 转化为数组中的位置
- (NSInteger)_pageIndexWithIndex:(NSInteger)index
{
    return index%_imageURLs.count;
}


#pragma mark - UIScrollViewDelegate
// 结束减速---即当scrollView滑动停止的时候(手动滑动的时候需要)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger offsetx = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self _scrollToIndex:offsetx];
}

// 保证pageControl 精确性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetx = (CGFloat)scrollView.contentOffset.x/scrollView.frame.size.width + 0.5;
    [_currentPageControl setCurrentPage:[self _pageIndexWithIndex:(NSInteger)offsetx]];
}

//
// 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _timerDuration = 0;
}


#pragma mark - V2.0改版
// 视图初始化
- (void)setupViews
{
    //
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = self.frame.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    collectView.backgroundColor = [UIColor whiteColor];
    collectView.dataSource = self;
    collectView.delegate = self;
    collectView.pagingEnabled = YES;
    collectView.showsHorizontalScrollIndicator = NO;
    [self addSubview:collectView];
    _scrollView = collectView;
    _collectionView = collectView;
    [collectView registerClass:[SSLinkageImageView class] forCellWithReuseIdentifier:kSSlinkageImageViewIder];
    
    // pagecontrol
    UIPageControl *control = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
    control.numberOfPages = _imageURLs.count;
    control.currentPageIndicatorTintColor = [UIColor whiteColor];
    control.pageIndicatorTintColor = SSColorWithRGB(60, 53, 53, 1);
    [self addSubview:control];
    control.enabled = NO;
    _currentPageControl = control;
}


#pragma mark - UICollectionViewDataSource
//
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageURLs.count*kSSLinkageRepeatCount;
}


// cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSLinkageImageView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSSlinkageImageViewIder forIndexPath:indexPath];
    NSInteger index = [self _pageIndexWithIndex:indexPath.row];
    cell.imageURL = _imageURLs[index];
    return cell;
}


#pragma mark - UICollectionViewDelegate
//
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self _pageIndexWithIndex:indexPath.row];
    //
    if ([_delegate respondsToSelector:@selector(linkPageView:index:)]) {
        [_delegate linkPageView:self index:index];
    }
    
    if ([_delegate respondsToSelector:@selector(linkPageView:actionAtIndex:)]) {
        [_delegate linkPageView:self actionAtIndex:index];
    }
}

@end


@implementation SSLinkageImageView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        AMDImageView *v = [[AMDImageView alloc]initWithFrame:self.bounds];
        [self addSubview:v];
        _imageView = v;
    }
    return self;
}

- (void)dealloc
{
    self.imageURL = nil;
}

//设置图像
- (void)setImageURL:(NSURL *)imageURL
{
    if (_imageURL != imageURL) {
        _imageURL = imageURL;
        
        // 如果包含主机地址--则是网络请求
        [_imageView setImageWithUrl:imageURL placeHolder:nil];
    }
}

@end







