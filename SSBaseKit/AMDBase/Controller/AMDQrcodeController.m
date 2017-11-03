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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 视图加载

//
- (void)initContentView
{
//    self.supportBackBt = YES;
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
    
    //输出设备
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    dispatch_queue_t outputqueue = dispatch_queue_create("qrcode", DISPATCH_QUEUE_SERIAL);
    [output setMetadataObjectsDelegate:self queue:outputqueue];
    
    //设置搜索区域
    //    CGFloat rectx = (CGFloat)40/320;
    //    CGFloat recty = (CGFloat)40/320;
    //    output.rectOfInterest = CGRectMake(rectx, rectx, 1.0-(2*rectx), 1.0-(2*recty));
    
    //捕获会话捕获输入或输出
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    self.captureSession = session;
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    //设置条码类型必须要放在 addoutpu 之后
    output.metadataObjectTypes = @[AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeQRCode];
    
    // 输出设备展示被捕获的数据流
    AVCaptureVideoPreviewLayer *viedolayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    viedolayer.frame = self.contentView.bounds;
    viedolayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.contentView.layer addSublayer:viedolayer];
    
    [session startRunning];
    
    [self initPopverView];
}

// 添加浮层效果和动画效果
- (void)initPopverView
{
    //浮层效果
    UIView *popverview = [[UIView alloc]initWithFrame:self.contentView.bounds];
    popverview.backgroundColor = [UIColor blackColor];
    popverview.alpha = 0.2;
    [self.contentView addSubview:popverview];
    
    //选中框
    UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake((SScreenWidth-210)/2, (self.contentView.frame.size.height-210)/2, 210, 210)];
    borderView.layer.borderWidth = 1;
    borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [popverview addSubview:borderView];
    
    //图片
    /*UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 210, 14)];
    imgView.image = imageFromPath(@"pic_QRcode_scan.png");
    [borderView addSubview:imgView];
    //动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 1;
    animation.repeatCount = FLT_MAX;
    animation.Autoreverses = YES;   //自动反面,在首次动画结束后，从结束的时候向前移动
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(210/2, 7)]; // 起始帧
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(210/2, 210)]; // 终了帧
    animation.fillMode = kCAFillModeForwards;
//    [imgView.layer addAnimation:animation forKey:@"move-layer"];*/

}


- (void)ClickBt_Back:(UIControl *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 二维码解析
//- (NSArray *)qrcodeParseWithCodeStr:(NSString *)codestr
//{
//    //目前仅支持两种数据
//    //店铺店址 http://m.wdwd.com/supplier/sindex/1K6ZP
//    //带推荐人的店铺地址 http://m.wdwd.com/supplier/sindex/1K6ZP/source/C9ZBGH67
//    if (![codestr hasPrefix:@"http"]) {
//        return nil;
//    }
//    NSURL *url = [[NSURL alloc]initWithString:codestr];
//    NSArray *params = [url.path componentsSeparatedByString:@"/"];
//
//    NSArray *resault = nil;
//    //店铺地址
//    switch (params.count) {
//        case 4:     //不带推荐人的店铺地址
//            resault = @[[params lastObject]];
//            break;
//        case 6:     //带推荐人的店铺地址
//            resault = @[params[3],[params lastObject]];
//            break;
//
//        default:
//            break;
//    }
//    return resault;
//}



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
//                _scanFinish = YES;
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



@end




