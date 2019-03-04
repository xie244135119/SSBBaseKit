//
//  AMDRootViewController.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-20.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDRootViewController.h"
#import "AMDRootNavgationBar.h"
#import "AMDBackControl.h"
#import <Masonry/Masonry.h>
#import "SSGlobalVar.h"


@interface AMDRootViewController () {
    // 是否使用系统导航
    BOOL _isUseSystemNav;
}
// 从xib中加载的话
@property(nonatomic) BOOL loadFromNib;
// 导航是否展示
@property(nonatomic) BOOL titileViewHidden;
@end

@implementation AMDRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 从xib中加载
        if (nibNameOrNil != nil) {
            _loadFromNib = YES;
        }
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
        if (_isUseSystemNav) {
            // 改造新页面
            [self p_setupRootViews];
        } else{
            [self _setupRootContentViews];
        }
    }
    
    //
    [self p_setupRootPerferences];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    if (!self.isViewLoaded){
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

// 状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //
}


#pragma mark -

- (instancetype)init
{
    if (_isUseSystemNav) {
        return [super init];
    }
    return [self initWithTitileViewShow:YES];
}

- (instancetype)initWithTitileViewShow:(BOOL)titleViewShow
{
    _titileViewHidden = !titleViewShow;
    _loadFromNib = NO;
    return self;
}

//
- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title titileViewShow:YES];
}

- (instancetype)initWithTitle:(NSString *)title
               titileViewShow:(BOOL)titleViewShow
{
    return [self initWithTitle:title titileViewShow:titleViewShow tabBarShow:NO];
}

- (instancetype)initWithTitle:(NSString *)title
               titileViewShow:(BOOL)titleViewShow
                   tabBarShow:(BOOL)tabbar
{
    _titileViewHidden = !titleViewShow;
    self.title = title;
    _loadFromNib = NO;
    return self;
}

- (void)_setupRootContentViews
{
    // 标题
    WEAKSELF
    if (!_titileViewHidden) {
        AMDRootNavgationBar *bar = [[AMDRootNavgationBar alloc]init];
        _titleView = bar;
        bar.title = self.title;
        [self.view addSubview:bar];
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(@0);
            // 底部距离规定的高度一直未44
            make.bottom.equalTo(weakSelf.mas_topLayoutGuide).with.offset(44);
        }];
        
        // 加载后退按钮
        if (_supportBack) {
            [self _loadBackBt];
        }
    }
    
    //内部视图
    UIView *contentvw = [[UIView alloc]init];
    _contentView = contentvw;
    contentvw.backgroundColor = SSColorWithRGB(246, 246, 246, 1);
    if (_titleView)
        [self.view insertSubview:contentvw belowSubview:_titleView];
    else
        [self.view addSubview:_contentView];
    
    [contentvw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
        if (weakSelf.titleView)
            make.top.equalTo(weakSelf.titleView.mas_bottom).with.offset(0);
        else
//            make.top.equalTo(self.mas_topLayoutGuide);
            make.top.equalTo(@0);
    }];
    self.view.multipleTouchEnabled = NO;
    self.view.backgroundColor = contentvw.backgroundColor;
}

// 加载后退视图
- (void)_loadBackBt
{
    if (_backItem == nil) {
        AMDBackControl *backbt = [[AMDBackControl alloc]initWithFrame:CGRectMake(0, 0, 44+10, 44)];
        _backItem = backbt;
        [backbt addTarget:self action:@selector(ClickBt_Back:) forControlEvents:UIControlEventTouchUpInside];
        self.titleView.leftViews = @[backbt];
    }
}



#pragma mark - PriavteAPI
//
- (void)setTitileViewHidden:(BOOL)titileViewHidden
{
    if (_titileViewHidden != titileViewHidden) {
        self.titleView.hidden = titileViewHidden;
        _titileViewHidden = titileViewHidden;
        
        WEAKSELF
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (titileViewHidden)
//                make.top.equalTo(self.mas_topLayoutGuide);
                make.top.equalTo(@0);
            else
                make.top.equalTo(weakSelf.titleView.mas_bottom).with.offset(0);
        }];
    }
}


/*后退按钮*/
-(void)ClickBt_Back:(UIControl *)sender
{
    //最后一层视图
    if ([self.navigationController.topViewController isKindOfClass:[self class]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
}


#pragma mark - 兼容ios 11
- (void)viewSafeAreaInsetsDidChange
{
    [super viewSafeAreaInsetsDidChange];
    
    // 做安全区域兼容
    WEAKSELF
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-weakSelf.view.safeAreaInsets.bottom));
    }];
}

#pragma mark - 页面跳转类型和动画
//
- (AMDControllerShowType)controllerShowType
{
    return AMDControllerShowTypePush;
}

// 是否需要动画
- (BOOL)controllerShowAnimate
{
    return YES;
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


#pragma mark - SET
//
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    // 设置标题
    self.titleView.title = title;
}


#pragma mark
#pragma mark - 二期改版
// 初始化方法
- (instancetype)initWithDefault {
    _isUseSystemNav = YES;
    return [super init];
}


#pragma mark - 视图加载
// 加载内容
// 只使用
- (void)p_setupRootViews {
    //内部视图
    UIView *contentvw = [[UIView alloc]init];
    _contentView = contentvw;
    contentvw.backgroundColor = SSColorWithRGB(246, 246, 246, 1);
    [self.view addSubview:contentvw];
    //    __weak typeof(self) wealself = self;
    [contentvw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.top.equalTo(@0);
    }];
    self.view.multipleTouchEnabled = NO;
    self.view.backgroundColor = contentvw.backgroundColor;
}


// 加载初始化配置
- (void)p_setupRootPerferences {
    //禁止7.0以后自动调位置 TableView滑动
    self.automaticallyAdjustsScrollViewInsets = NO;
}




@end





