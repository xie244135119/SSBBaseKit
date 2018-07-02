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

typedef NS_ENUM(NSUInteger, XQScrollLocationType) {
    SSScrollLocationTypeLeft,           //左侧
    SSScrollLocationTypeMiddle,         //中间
    SSScrollLocationTypeRight           //右侧
};


@interface SSLinkageImageView : UIControl

@property(nonatomic, weak) AMDImageView *imageView;        //图片视图
@property(nonatomic, strong) NSURL *imageURL;      //图片名称或url地址
@property(nonatomic) NSInteger imageIndex;          //图片索引值

@end

@interface SSLinkageView()  <UIScrollViewDelegate>
{
//    __weak AMDImageView *_topImageView;         //顶部视图
    
    __weak SSLinkageImageView *_leftImageView;              //左侧视图
    __weak SSLinkageImageView *_middleImageView;            //中间视图
    __weak SSLinkageImageView *_rightImageView;             //右侧视图
    NSTimer *_currentTimer;                                 //当前定时器
}

@end

@implementation SSLinkageView

- (void)dealloc
{
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
    }
    return self;
}

- (void)invalidate
{
    [_currentTimer invalidate];
    _currentTimer = nil;
}

- (void)prepareLoad
{
    // 使之前的定时器无效
    [self invalidate];
    // 初始化配置
    [self config];
}

#pragma mark - 初始化
- (void)config
{
    _currentTimer = [NSTimer scheduledTimerWithTimeInterval:_linkageDuration target:self selector:@selector(change:) userInfo:nil repeats:YES];
    //避免滑动拖拽时造成timer停止工作
    [[NSRunLoop currentRunLoop] addTimer:_currentTimer forMode:UITrackingRunLoopMode];
    [self initView];
}


#pragma mark - 视图加载
//
- (void)initView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.canCancelContentTouches = NO;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    scrollView.contentSize = CGSizeMake(width*3, height);
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    //加载默认视图
    for (NSInteger i = 0; i<3; i++) {
        //
        SSLinkageImageView *imgview = [[SSLinkageImageView alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
        [imgview addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:imgview];
        //
        switch (i) {
            case 0:{
                _leftImageView = imgview;
                imgview.imageURL = _imageURLs[_imageURLs.count-1];
                imgview.imageIndex = _imageURLs.count-1;
            }
                break;
            case 1:{
                _middleImageView = imgview;
                imgview.imageURL = _imageURLs[0];
                imgview.imageIndex = 0;
            }
                break;
            case 2:{
                _rightImageView = imgview;
                imgview.imageURL = _imageURLs.count>1?_imageURLs[1]:_imageURLs[0];
                imgview.imageIndex = 1;
            }
                break;
            default:
                break;
        }
    }
    
    // 加载pageControl
    [self initPageControlView];
    
    // 即将切换中间视图
    if ([_delegate respondsToSelector:@selector(linkPageView:willScrollToImage:atIndex:)]) {
        [_delegate linkPageView:self
              willScrollToImage:_middleImageView
                        atIndex:_middleImageView.imageIndex];
    }
    if ([_delegate respondsToSelector:@selector(linkPageView:didScrollToImage:atIndex:)]) {
        [_delegate linkPageView:self
               didScrollToImage:_middleImageView
                        atIndex:_middleImageView.imageIndex];
    }
    
    // 如果图片只有1张的情况下 不允许滚动
    if (_imageURLs.count == 1) {
        scrollView.scrollEnabled = NO;
        _currentPageControl.hidden = YES;
        [self invalidate];  //定时器无效
    }
}

//pagecontrol效果
- (void)initPageControlView
{
    UIPageControl *control = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
    control.numberOfPages = _imageURLs.count;
    control.currentPageIndicatorTintColor = [UIColor whiteColor];
    control.pageIndicatorTintColor = SSColorWithRGB(60, 53, 53, 1);
    [self addSubview:control];
    control.enabled = NO;
    _currentPageControl = control;
}


#pragma mark - SET
- (void)setimageURLs:(NSArray *)imageURLs
{
    if (_imageURLs != imageURLs) {
        _imageURLs = imageURLs;
        
        if (imageURLs) {
            [self config];
        }
    }
}



#pragma mark - 定时器处理
- (void)change:(NSTimer *)timer
{
    NSInteger offset = _scrollView.contentOffset.x+self.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}


#pragma mark - 按钮事件
// 选中某一个图片视图
- (void)clickAction:(SSLinkageImageView *)sender
{
    if ([_delegate respondsToSelector:@selector(linkPageView:index:)]) {
        [_delegate linkPageView:self index:sender.imageIndex];
    }
    
    if ([_delegate respondsToSelector:@selector(linkPageView:actionAtIndex:)]) {
        [_delegate linkPageView:self actionAtIndex:sender.imageIndex];
    }
}


#pragma mark - 数据处理
//加载一张页面显示视图--用于处理--加载后端处理操作
- (void)dealInBackgroundWithType:(XQScrollLocationType)type
{
//    _topImageView.hidden = NO;
//    _topImageView.layer.borderWidth = 1;
    
    // 即将切换中间视图
    if ([_delegate respondsToSelector:@selector(linkPageView:willScrollToImage:atIndex:)]) {
        [_delegate linkPageView:self
               willScrollToImage:_middleImageView
                        atIndex:_middleImageView.imageIndex];
    }
    
    //后台处理图片的换位问题
    switch (type) {
        case SSScrollLocationTypeLeft:{
//            _topImageView.image = _leftImageView.imageView.image;
            
            //设置右侧视图
            _rightImageView.imageIndex = _middleImageView.imageIndex;
            _rightImageView.imageURL = _middleImageView.imageURL;
            //设置中间视图
            _middleImageView.imageIndex = _leftImageView.imageIndex;
            _middleImageView.imageURL = _leftImageView.imageURL;
            
            //设置左侧视图的效果
            NSInteger leftindex = _leftImageView.imageIndex;
            if (leftindex == 0) {   //首页
                leftindex = _imageURLs.count-1;
            }
            else{
                leftindex--;
            }
            _leftImageView.imageIndex = leftindex;
            _leftImageView.imageURL = _imageURLs[leftindex];
            
        }
            break;
        case SSScrollLocationTypeMiddle:{//中间
//            _topImageView.image = _middleImageView.image;
        }
            break;
        case SSScrollLocationTypeRight:{
//            _topImageView.image = _rightImageView.imageView.image;
            
            //设置左侧视图
            _leftImageView.imageIndex = _middleImageView.imageIndex;
            _leftImageView.imageURL = _middleImageView.imageURL;
            
            //设置中间视图
            _middleImageView.imageIndex = _rightImageView.imageIndex;
            _middleImageView.imageURL = _rightImageView.imageURL;
            
            //设置左侧视图的效果
            NSInteger rightIndex = _rightImageView.imageIndex;
            if (rightIndex == _imageURLs.count-1) {   //
                rightIndex = 0;
            }
            else {
                rightIndex++;
            }
            
            if (_imageURLs.count > rightIndex) {
                _rightImageView.imageIndex = rightIndex;
                _rightImageView.imageURL = _imageURLs[rightIndex];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    [_currentPageControl setCurrentPage:_middleImageView.imageIndex];
    
    // 做滑动处理
    if ([_delegate respondsToSelector:@selector(linkPageView:didScrollToImage:atIndex:)]) {
        [_delegate linkPageView:self
               didScrollToImage:_middleImageView
                        atIndex:_middleImageView.imageIndex];
    }
}


#pragma mark - UIScrollViewDelegate
// 结束减速---即当scrollView滑动停止的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self dealOffSetX:scrollView.contentOffset.x];
}

// 结束动画的时候
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)dealOffSetX:(CGFloat )offsetx
{
    XQScrollLocationType type = 0;
    if(offsetx > 320) {//右滑
        type = SSScrollLocationTypeRight;
    }
    else if(offsetx < 320){//左滑
        type = SSScrollLocationTypeLeft;
    }
    else{//当前状态--不做任何处理
        type = SSScrollLocationTypeMiddle;
    }
    [self dealInBackgroundWithType:type];
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














