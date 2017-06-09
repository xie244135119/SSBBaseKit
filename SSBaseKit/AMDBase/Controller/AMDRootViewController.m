//
//  AMDRootViewController.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDRootViewController.h"
//#import "AMDUMSDKManager.h"
#import "AMDRootNavgationBar.h"
//#import "AMDTool.h"
#import "AMDBackControl.h"
#import "Masonry.h"
#import "SSGlobalVar.h"
//#import "ATAColorConfig.h"


@interface AMDRootViewController ()

@property(nonatomic) BOOL loadFromNib;     //从xib中加载的话
//导航是否展示
@property(nonatomic) BOOL titileViewHidden;
//底部tabbar的高度是否展示
@property(nonatomic) BOOL tabBarHidden;
@end

@implementation AMDRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 从xib中加载
        _loadFromNib = YES;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ %s",[self class],__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //当从nib中加载的时候 不加载导航
    if (!_loadFromNib) {
        [self initRootContentView];
    }
    
    //禁止7.0以后自动调位置 TableView滑动
    self.automaticallyAdjustsScrollViewInsets=NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [AMDUMSDKManager endLogPageView:[[self class] description]];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [AMDUMSDKManager beginLogPageView:[[self class] description]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
//    [AMDTool clearMembory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    //    if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
    if (!self.isViewLoaded){
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}


// 状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
//    return [[LoginInfoStorage sharedStorage] statusBarStyle];
}



#pragma mark -

- (instancetype)init
{
    return [self initWithTitle:nil];
}
//
- (instancetype)initWithTitle:(NSString *)title
{
//    if (self = [super init]) {
        //默认展示导航 不展示tabbar
        _titileViewHidden = NO;
        _tabBarHidden = YES;
        self.title = title;
    _loadFromNib = NO;
//    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
               titileViewShow:(BOOL)titleViewShow
                   tabBarShow:(BOOL)tabbar
{
    //    if (self = [super initWithNibName:nil bundle:nil]) {
    _titileViewHidden = !titleViewShow;
    _tabBarHidden = !tabbar;
    self.title = title;
    _loadFromNib = NO;
    //    }
    return self;
}

- (void)initRootContentView
{
    NSInteger h = 0;
    NSInteger w = self.view.frame.size.width;
    
    if (!_titileViewHidden) {//标题
        h = 64;
        AMDRootNavgationBar *bar = [[AMDRootNavgationBar alloc]initWithFrame:CGRectMake(0, 0, w, h)];
//        bar.naviationBarColor = nav_background_color;
        _titleView = bar;
        bar.title = self.title;
        [self.view addSubview:bar];
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@(h));
            make.top.equalTo(@0);
        }];
    }
    
    //内部视图
    UIView *contentvw = [[UIView alloc]init];
    _contentView = contentvw;
    contentvw.backgroundColor = ColorWithRGB(246, 246, 246, 1);
//    contentvw.layer.borderWidth = 1;
    if (_titleView)
        [self.view insertSubview:contentvw belowSubview:_titleView];
    else
        [self.view addSubview:_contentView];
    
    [contentvw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        if (_titleView)
            make.top.equalTo(_titleView.mas_bottom).with.offset(0);
        else
            make.top.equalTo(@0);
    }];
    self.view.multipleTouchEnabled = NO;
}


#pragma mark - PriavteAPI
//
- (void)setTitileViewHidden:(BOOL)titileViewHidden
{
    if (_titileViewHidden != titileViewHidden) {
        self.titleView.hidden = titileViewHidden;
        _titileViewHidden = titileViewHidden;
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (titileViewHidden)
                make.top.equalTo(self.mas_topLayoutGuide);
            else
                make.top.equalTo(_titleView.mas_bottom).with.offset(0);
        }];
    }
}


-(void)setSupportBackBt:(BOOL)supportBackBt
{
    if (_supportBackBt != supportBackBt) {
        _supportBackBt = supportBackBt;
        
        AMDBackControl *control = (AMDBackControl *)[self.titleView viewWithTag:50];
        if (supportBackBt) {
            if (control == nil) {
                AMDBackControl *backbt = [[AMDBackControl alloc]initWithFrame:CGRectMake(0, 0, 44+10, 44)];
                backbt.tag = 50;
                _backItem = backbt;
                [backbt setImage:imageFromBundleName(@"CommonUIModule.bundle", @"back_normal.png") forState:UIControlStateNormal];
                [backbt setImage:imageFromBundleName(@"CommonUIModule.bundle", @"back_selected.png") forState:UIControlStateHighlighted];
                [backbt setImage:imageFromBundleName(@"CommonUIModule.bundle", @"back_selected.png") forState:UIControlStateSelected];
                [backbt addTarget:self action:@selector(ClickBt_Back:) forControlEvents:UIControlEventTouchUpInside];
                self.titleView.leftViews = @[backbt];
            }
        }
        control.hidden = !supportBackBt;
    }
}


- (void)setMessageCount:(NSInteger)messageCount
{
    if (_messageCount != messageCount) {
        _messageCount = messageCount;
        
        AMDBackControl *control = (AMDBackControl *)[self.titleView viewWithTag:50];
        control.mesRemindLabel.text = [NSString stringWithFormat:@"(%li)",(long)messageCount];
    }
}

/*后退按钮*/
-(void)ClickBt_Back:(UIControl *)sender
{
    //最后一层视图
    if (self.navigationController.viewControllers.count == 2) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillLayoutSubviews
{
//    self.contentView.layer.borderWidth = 1;
    // 当视图发生改变的时候
    [super viewWillLayoutSubviews];
}


- (AMDControllerShowType)controllerShowType
{
    return AMDControllerShowTypePush;
}

// 处理KVC机制
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@" 不存在的属性 %@ %@ ",key,value);
}



#pragma mark - 引导图相关处理 <目前还未使用>
- (BOOL)prefersGuideShow
{
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/AppControllerGuide.plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        dict = [[NSMutableDictionary alloc]init];
    }
    NSString *description = [self description];
    if ([dict.allKeys containsObject:description]) {
        return [dict[description] boolValue];
    }
    return NO;
}



#pragma mark - 重写description方法
//直接返回类名
-(NSString *)description
{
    return [[self class] description];
}


@end




//// 自定义后退按钮
//@implementation AMDBackControl
//{
//    __weak UIImageView *_imageView;
//}
//
//- (void)dealloc
//{
//    self.imageNormalName = nil;
//    self.imageSelectName = nil;
//    self.imageNormalName2 = nil;
//    self.imageSelectName2 = nil;
//}
//
//- (id)init
//{
//    if (self = [super init]) {
//        [self initContentView2];
//    }
//    return self;
//}
//
//
//- (id)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self initContentView];
//    }
//    
//    return self;
//}
//
//- (void)initContentView
//{
//    // 图片
//    UIImageView *imgView = [[UIImageView alloc]init];
//    [self addSubview:imgView];
//    //        imgView.layer.borderWidth = 1;
//    _imageView = imgView;
//    
//    // 消息数量
//    UILabel *messagecountlb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 44)];
//    messagecountlb.font = FontWithName(@"", 13);
//    messagecountlb.textColor = ColorWithRGB(75, 75, 75, 1);
//    [self addSubview:messagecountlb];
//    _mesRemindLabel = messagecountlb;
//}
//
//- (void)initContentView2
//{
//    // 图片
//    UIImageView *imgView = [[UIImageView alloc]init];
//    [self addSubview:imgView];
//    _imageView = imgView;
//    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@5);
//        make.height.width.equalTo(@(24));
//        make.centerY.equalTo(self);
//    }];
//    
//    // 消息数量
//    UILabel *messagecountlb = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 50, 44)];
//    messagecountlb.font = FontWithName(@"", 13);
//    messagecountlb.textColor = ColorWithRGB(75, 75, 75, 1);
//    [self addSubview:messagecountlb];
//    _mesRemindLabel = messagecountlb;
//    [messagecountlb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@30);
//        make.top.equalTo(@0);
//        make.width.equalTo(@50);
//        make.height.equalTo(@44);
//    }];
//    
//}
//
////- (void)setSelected:(BOOL)selected
////{
////    [super setSelected:selected];
////    
////    //选中的时候
////    _imageView.image = selected?[UIImage imageNamed:_imageSelectName]:[UIImage imageNamed:_imageNormalName];
////}
//
//// 高亮状态
//- (void)setHighlighted:(BOOL)highlighted
//{
//    [super setHighlighted:highlighted];
//    
//    // 选中的时候
//    if (_imageSelectName) {
//        _imageView.image = highlighted?[UIImage imageNamed:_imageSelectName]:[UIImage imageNamed:_imageNormalName];
//    }
//    
//    if (_imageSelectName2) {
//        _imageView.image = highlighted?[UIImage imageNamed:_imageSelectName2]:[UIImage imageNamed:_imageNormalName2];
//    }
//}
//
//
//
//#pragma mark - SET方法
//- (void)setImageNormalName:(NSString *)imageNormalName
//{
//    if (_imageNormalName != imageNormalName) {
//        _imageNormalName = imageNormalName;
//        
//        if (imageNormalName) {
//            _imageView.image = [UIImage imageNamed:imageNormalName];
//            CGSize imagesize = _imageView.image.size;
//            _imageView.frame = CGRectMake(5, (self.frame.size.height-imagesize.height)/2, imagesize.width, imagesize.height);
//        }
//    }
//}
//
//- (void)setImageNormalName2:(NSString *)imageNormalName2
//{
//    if (_imageNormalName2 != imageNormalName2) {
//        _imageNormalName2 = imageNormalName2;
//        
//        if (imageNormalName2) {
//            _imageView.image = [UIImage imageNamed:imageNormalName2];
//        }
//    }
//}
//
//
//#pragma mark - 重写父类方法获取点击
////开始点击的时候
////- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
////{
////    [self setSelected:YES];
////    return YES;
////}
////
//////取消点击的时候
////- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
////{
////    [self setSelected:NO];
////}
////
////- (void)cancelTrackingWithEvent:(UIEvent *)event
////{
////    [self setSelected:NO];
////}
//
//@end



