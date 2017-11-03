//
//  AMDImageCropController.m
//  AppMicroDistribution
//
//  Created by Fuerte on 16/7/28.
//  Copyright © 2016年 SunSet. All rights reserved.
//

#import "SSImageCropController.h"
#import "SSGlobalVar.h"


@interface SSImageCropController ()
{
    __weak UIImageView *_showImgView;                   //显示的视图
    __weak UIView *_overlayView;                       //蒙版视图
    
    __weak UIView *_selectRegionView;                   //选中区域视图
    CGRect _newImageRect;                                //新的位置区域
    CGRect _oldImageRect;                               //旧的位置区域
    CGRect _largeImageRect;                             //最大的大小
    CGRect _smallImageRect;                             //设置的最小区域
}
@end

@implementation SSImageCropController

- (void)dealloc
{
    self.orignImage = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     [self initData];
    [self initContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark  
#pragma mark 视图初始化
- (void)initContentView
{
    self.view.backgroundColor = [UIColor blackColor];
    
    // 显示视图
    UIImage *image = _orignImage;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:_oldImageRect];
    imgView.image = image;
    [self.view addSubview:imgView];
    _showImgView = imgView;

    // 选中区域视图
    [self initSelectRegionView];
    
    // 后层蒙版视图
    UIView *layerView = [[UIView alloc]initWithFrame:self.view.bounds];
    layerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:layerView];
    _overlayView = layerView;
    [self overlayView];
    
    // 下方的操作按钮
    [self initOperationBtView];
    
    // 添加手势
    [self addGestureRecognizers];
}


// 覆盖选中视图(居中显示)
- (void)overlayView
{
    CGFloat width = self.view.frame.size.width;
    
    //  线条
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    masklayer.strokeColor = [[UIColor whiteColor] CGColor];
    masklayer.lineWidth = 1;
    // 路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, CGRectMake(0, 0, width, _selectRegionView.frame.origin.y));
    CGPathAddRect(path, nil, CGRectMake(0, _selectRegionView.frame.origin.y+_selectRegionView.frame.size.height, width, _selectRegionView.frame.origin.y));
    masklayer.path = path;
    
    _overlayView.layer.mask = masklayer;
    CGPathRelease(path);
}

// 选择操作视图
- (void)initSelectRegionView
{
    if (_cropScale != 1) {
        UIView *selectRegionView = [[UIView alloc]initWithFrame:_cropFrame];
        selectRegionView.layer.borderColor = [[UIColor whiteColor] CGColor];
        selectRegionView.layer.borderWidth = 1;
        [self.view addSubview:selectRegionView];
        _selectRegionView = selectRegionView;
    }
}

// 底部操作视图
- (void)initOperationBtView
{
    // 底部视图
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width, 80)];
    bottomView.backgroundColor = SSColorWithRGB(0, 0, 0, 0.5);
    [self.view addSubview:bottomView];
    
    // 取消按钮
    UIButton *cancelbt = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbt setTitle:@"取消" forState:UIControlStateNormal];
    cancelbt.tag = 1;
    [cancelbt setFrame:CGRectMake(20, self.view.frame.size.height-50, 50, 30)];
    [cancelbt addTarget:self action:@selector(clickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelbt];
    
    // 确定按钮
    UIButton *surebt = [UIButton buttonWithType:UIButtonTypeCustom];
    surebt.tag = 2;
    [surebt setTitle:@"确定" forState:UIControlStateNormal];
    [surebt setFrame:CGRectMake(self.view.frame.size.width-50-20,self.view.frame.size.height-50 , 50, 30)];
    [surebt addTarget:self action:@selector(clickSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:surebt];
}

// 初始化相关数据
- (void)initData
{
    // 选中区域
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    if (CGRectEqualToRect(_cropFrame, CGRectZero)) {
        _cropFrame = CGRectMake(0, (height-width)/2, width, width);
    }
    
    // 计算图形显示默认尺寸
    CGFloat h = width*_orignImage.size.height/_orignImage.size.width;
    _oldImageRect = CGRectMake(0, (self.view.frame.size.height-h)/2, width, h);
    
    // 设置最大尺寸
    if (_maxScale == 0) {  _maxScale = 2; }
    _largeImageRect = CGRectMake(0, 0, _maxScale*_oldImageRect.size.width, _maxScale*_oldImageRect.size.height);
    
    // 设置最小尺寸
    if (_minScale == 0) {  _minScale = 1; }
    _smallImageRect = CGRectMake(0, 0, _minScale*_oldImageRect.size.width, _minScale*_oldImageRect.size.height);;
}


#pragma mark - SET方法
//
- (void)setCropScale:(CGFloat)cropScale
{
    _cropScale = cropScale;
    
    // 设置剪裁比例
    if (cropScale > 0) {
        
        CGFloat height = (CGFloat)SScreenWidth/cropScale;
        _cropFrame = CGRectMake(0, (SScreenHeight-height)/2, SScreenWidth, SScreenHeight);
    }
}


#pragma mark - 按钮事件
- (void)clickAction:(UIButton *)sender
{
    //
    switch (sender.tag) {
        case 1:     //取消
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 2:     //保存
        
            break;
        default:
            break;
    }
}


#pragma mark - 手势相关
- (void)addGestureRecognizers
{
    // 拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.view addGestureRecognizer:pan];
    
    //  放大手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGestureRecognizer:)];
//    pinch.scale = 1.5;
    [self.view addGestureRecognizer:pinch];
}


// 拖动手势
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:pan.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            _showImgView.center = CGPointMake(_showImgView.center.x+translation.x, _showImgView.center.y+translation.y);
            break;
        case UIGestureRecognizerStateEnded:
        {
            // 如果超出选中区域位置，归位
            // 小图的话 归位上或者下
            CGRect newframe = [self fixMoveOverflow:_showImgView.frame];
            [UIView  animateWithDuration:0.25 animations:^{
                _showImgView.frame = newframe;
            }];
        }
            break;
        default:
            break;
    }
    // 重新规划中心位置
    [pan setTranslation:CGPointZero inView:pan.view];
}

// 修正方位
- (CGRect)fixMoveOverflow:(CGRect)aNewFrame {
    CGRect newFrame = aNewFrame;
    // horizontally
    if (aNewFrame.origin.x > self.cropFrame.origin.x)
    {
        newFrame.origin.x = self.cropFrame.origin.x;
    }
    // CGRectGetMaxX 获取x轴上最大的坐标
    if (CGRectGetMaxX(aNewFrame) < self.cropFrame.size.width)
    {
        newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width;
    }

    if (_showImgView.frame.size.height < _cropFrame.size.height) {
        // 超出了上方界限
        if (CGRectGetMinY(aNewFrame) < CGRectGetMinY(_cropFrame)) {
            newFrame.origin.y = _cropFrame.origin.y;
        }
        // 超出了下方界限
        if (CGRectGetMaxY(aNewFrame) > CGRectGetMaxY(_cropFrame)) {
            newFrame.origin.y = _cropFrame.origin.y+(_cropFrame.size.height-newFrame.size.height);
        }
    }
    else {
        // 超过当前选中区域的情况下
        // 超过上方边界
        if (CGRectGetMinY(aNewFrame) > CGRectGetMinY(_cropFrame)) {
            newFrame.origin.y = _cropFrame.origin.y;
        }
        // 超过下方边界
        if (CGRectGetMaxY(aNewFrame) < CGRectGetMaxY(_cropFrame)) {
            newFrame.origin.y = _cropFrame.origin.y+_cropFrame.size.height-aNewFrame.size.height;
        }
    }
    return newFrame;
}


// 放大手势
- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)gestureRecognizer
{
    CGFloat scale = gestureRecognizer.scale;
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:                 //开始的时候
        {
            
        }
            break;
        case UIGestureRecognizerStateChanged:               //移动的时候
        {
            // scale
            _showImgView.transform = CGAffineTransformScale(_showImgView.transform, scale, scale);
        }
            break;
        case UIGestureRecognizerStateEnded:                 //结束的时候
        {
            CGRect newFrame = _showImgView.frame;
            newFrame = [self fixScaleOverflow:newFrame];
            newFrame = [self fixMoveOverflow:newFrame];
            [UIView animateWithDuration:0.25 animations:^{
                _showImgView.frame = newFrame;
            }];
        }
            break;
        default:
            break;
    }
    
    // 将当前的scale位置
    gestureRecognizer.scale = 1;
}


// 修复放大之后的frame
// 最大倍数不能超过2倍
- (CGRect)fixScaleOverflow:(CGRect)aNewframe
{
    CGRect newFrame = aNewframe;
    // 超过最大宽度的时候
    if (aNewframe.size.width > _largeImageRect.size.width) {
        newFrame = _largeImageRect;
    }
    
    // 最小宽度小于设置的最小值的时候
    if (aNewframe.size.width < _smallImageRect.size.width) {
        newFrame = _smallImageRect;
    }
    
    //
    return newFrame;
}



#pragma mark - 图片剪裁
//
- (UIImage *)cropImage
{
    // 如果是图形不超过剪裁区域
    if (CGRectContainsRect(_cropFrame, _showImgView.frame)) {
        return _showImgView.image;
    }
    
    // 获取cropframe 在imageView上面的位置
    CGRect frame = [self.view convertRect:_selectRegionView.frame toView:_showImgView];
    
    // 原始图形大小
    CGImageRef orginImageRef = [_showImgView.image CGImage];
    CGFloat radioius = CGImageGetWidth(_showImgView.image.CGImage)/SScreenWidth;
    CGImageRef imageRef = CGImageCreateWithImageInRect(orginImageRef, CGRectMake(frame.origin.x*radioius, frame.origin.y*radioius, frame.size.width*radioius, frame.size.height*radioius));
    UIImage *image = [[UIImage alloc]initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}


#pragma mark - 保存 取消
// 保存
- (void)clickSaveAction:(UIButton *)senderself
{
    UIImage *image = [self cropImage];
    
    if (image) {
        if (_completeBlock) {
            _completeBlock(image, nil);
        }
    }
}

// 取消
- (void)clickCancelAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end















