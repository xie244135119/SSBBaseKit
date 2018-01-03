//
//  AMDQrcodeController.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-6-5.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDQrcodeController.h"
#import <AVFoundation/AVFoundation.h>
#import "SSGlobalVar.h"

@interface AMDQrcodeController() <AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL _scanFinish;               //已经扫描结束
}
@property(nonatomic,strong) AVCaptureSession *captureSession;           //
@end

@implementation AMDQrcodeController


- (void)dealloc
{
    self.captureSession = nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @autoreleasepool {
        [self performSelectorOnMainThread:@selector(initContentView) withObject:nil waitUntilDone:NO];
    }
}


#pragma mark - 视图加载
//
- (void)initContentView
{
    // 遮罩效果
    [self initPopverView];
    
    //输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc]initWithDevice:device error:&error];
    if (input == nil || error) {
        if (_scanAction) {
            _scanAction(nil, error);
        }
        return;
    }
    
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    self.captureSession = session;
    //捕获会话捕获输入或输出
    if (![session canAddInput:input]) {
        if (_scanAction) {
            _scanAction(nil, error);
        }
        return;
    }
    [session addInput:input];
    
    
    //输出设备
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    dispatch_queue_t outputqueue = dispatch_queue_create("qrcode", DISPATCH_QUEUE_SERIAL);
    [output setMetadataObjectsDelegate:self queue:outputqueue];
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    //设置条码类型必须要放在 addoutput 之后
    output.metadataObjectTypes = @[AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode];
    
    // 输出设备展示被捕获的数据流
    AVCaptureVideoPreviewLayer *viedolayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    viedolayer.frame = self.contentView.bounds;
    viedolayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.contentView.layer addSublayer:viedolayer];
    // 开始显示
    [session startRunning];
}

// 添加浮层效果和动画效果
- (void)initPopverView
{
    //浮层效果
    CGRect frame = self.contentView.bounds;
    CGRect scanframe = CGRectMake(60, 150, frame.size.width-60*2, frame.size.width-60*2);
    
    // 选中框大小
    CGMutablePathRef scanrectpath = CGPathCreateMutable();
    CGPathAddRect(scanrectpath, NULL, scanframe);
    
    // 位置
    CGMutablePathRef path = CGPathCreateMutable();
    // 第一种方式
//    CGPathMoveToPoint(path, NULL, frame.origin.x, frame.origin.y);
//    CGPathAddLineToPoint(path, NULL, frame.origin.x, frame.origin.y+frame.size.height);
//    CGPathAddLineToPoint(path, NULL, frame.origin.x+frame.size.width, frame.origin.y+frame.size.height);
//    CGPathAddLineToPoint(path, NULL, frame.origin.x+frame.size.width, frame.origin.y);
//    CGPathAddLineToPoint(path, NULL, frame.origin.x, frame.origin.y);
//    CGPathAddPath(path, NULL, scanrectpath);
    
    // 第二种方式
    CGPathAddRect(path, NULL, frame);
    CGPathAddPath(path, NULL, scanrectpath);
    
    // 默认大小
    CAShapeLayer *popverlayer = [CAShapeLayer layer];
    popverlayer.path = path;
    popverlayer.fillColor = [SSColorWithRGB(0, 0, 0, 0.3) CGColor];
    // 采用奇偶规则
    popverlayer.fillRule = @"even-odd";
    [self.contentView.layer addSublayer:popverlayer];
    
    //选中框<类似支付宝效果>
    CAShapeLayer *scanLayer = [CAShapeLayer layer];
    scanLayer.strokeColor = [UIColor blueColor].CGColor;
    scanLayer.fillColor = [UIColor clearColor].CGColor;
    scanLayer.lineWidth = 0.5;
    scanLayer.path = scanrectpath;
    [self.contentView.layer insertSublayer:scanLayer above:popverlayer];
    //
    CGFloat cornerspcaewidth = scanframe.size.width-20*2-4;
    CGRect cornerrect = CGRectMake(scanframe.origin.x+2, scanframe.origin.y+2, scanframe.size.width-4, scanframe.size.width-4);
    CAShapeLayer *scancornerlayer = [CAShapeLayer layer];
    scancornerlayer.path = [UIBezierPath bezierPathWithRect:cornerrect].CGPath;
    scancornerlayer.strokeColor = scanLayer.strokeColor;
    scancornerlayer.fillColor = [UIColor clearColor].CGColor;
    scancornerlayer.lineWidth = 4;
    scancornerlayer.lineDashPattern = @[@20,@(cornerspcaewidth),@20,@0];
    [scanLayer addSublayer:scancornerlayer];

    // 扫描动画效果
    CALayer *linelayer = [CALayer layer];
    linelayer.backgroundColor = scanLayer.strokeColor;
    linelayer.position = scanframe.origin;
    linelayer.anchorPoint = CGPointMake(0, 0);
    linelayer.opacity = 0;
    linelayer.bounds = CGRectMake(0, 0, scanframe.size.width, 2);
    [scanLayer addSublayer:linelayer];

    CGFloat animateduration = 2;
    // 动画效果 渐隐效果+滑动效果
    CAMediaTimingFunction *timfunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *opacityanimate = [CABasicAnimation animation];
    opacityanimate.keyPath = @"opacity";
    opacityanimate.fromValue = @0;
    opacityanimate.toValue = @1;
    opacityanimate.duration = animateduration;
    opacityanimate.timingFunction = timfunction;
    opacityanimate.repeatCount = INFINITY;
    [linelayer addAnimation:opacityanimate forKey:@"opacity"];
    
    CABasicAnimation *positionanimate = [CABasicAnimation animation];
    positionanimate.keyPath = @"position.y";
    positionanimate.duration = animateduration;
    positionanimate.byValue = @(scanframe.size.height);
    positionanimate.repeatCount = INFINITY;
    positionanimate.timingFunction = timfunction;
    [linelayer addAnimation:positionanimate forKey:@"position.y"];
    
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
//
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.captureSession stopRunning];
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *codeValue = nil;
        for (AVMetadataObject * object in metadataObjects) {
            if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                AVMetadataMachineReadableCodeObject *a = (AVMetadataMachineReadableCodeObject *)object;
                codeValue = a.stringValue;
                [weakself.captureSession stopRunning];
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //扫描出了二维码
            if (codeValue.length > 0) {
                if ([_delegate respondsToSelector:@selector(viewController:object:)]) {
                    [_delegate viewController:self object:codeValue];
                }
                
                if (_scanAction) {
                    _scanAction(codeValue, nil);
                }
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        });
    });
}



#pragma mark - 创建网格
// 创建网格视图
- (void)_createGridOnLayer:(CALayer *)layer
{
    // 每5像素创建一条线条
//    CAGradientLayer
}





@end








