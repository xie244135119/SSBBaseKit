//
//  AMDTabbarController.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-5-21.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "AMDTabbarController.h"
#import "Masonry.h"
#import "SSGlobalVar.h"
#import "AMDLineView.h"
//#import "AMDTabbarItem.h"
//#import "ATAColorConfig.h"

// tabbar背景图
@interface AMDTabBarView : UIView
@end

@interface AMDTabbarController ()
{
//    __weak UIView *_currentTabbar;
//    AMDTabbarItem *_retainItem;                 //持有item
}
@property(nonatomic,strong) NSArray *itemTitles;//所有的itemtitles
@property(nonatomic,strong) NSArray *itemImages;//所有的item 正常图片
@property(nonatomic,strong) NSArray *itemSelectImages;//所有的item 选中时候的图片

@end

@implementation AMDTabbarController

- (void)dealloc
{
    self.itemTitles = nil;
    self.itemImages = nil;
    self.itemSelectImages = nil;
//    self.amdViewControllers = nil;
    
    NSLog(@"%@ %s",NSStringFromClass([self class]),__FUNCTION__);
}

- (instancetype)initWithItemsTitles:(NSArray *)titles itemImages:(NSArray *)imgs itemSelctImages:(NSArray *)selectimgs
{
    self.itemTitles = titles;
    self.itemImages = imgs;
    self.itemSelectImages = selectimgs;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self resetTabbarTitles:_itemTitles images:_itemImages selectImages:_itemSelectImages];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// override 系统方法
- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController
{
//    [super setSelectedViewController:selectedViewController];
    
    // 选中当前项目
    NSInteger index = [self.viewControllers indexOfObject:selectedViewController];
    [self selectTabbarIndex:index];
}



#pragma mark - 视图加载
// 重新初始化当前的tabbar
- (void)resetTabbarTitles:(NSArray *)titles images:(NSArray *)images selectImages:(NSArray *)selectimgs
{
    // 隐藏视图
    [self hideTabBar];
    //背景色
    UIView *barvw = [[UIView alloc]init];
    barvw.backgroundColor = ColorWithRGB(248, 248, 248, 1);
    [self.view addSubview:barvw];
    [barvw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@49);
    }];
    _amdTabBar = barvw;
    
    // 线条
//    AMDTabBarView *shadowvw = [[AMDTabBarView alloc]initWithFrame:CGRectMake(0, 0, APPWidth, 60)];
//    [barvw addSubview:shadowvw];
    AMDLineView *line = [[AMDLineView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5) Color:ColorWithRGB(200, 200, 200, 0.7)];
    [barvw addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
//    UIImageView *line = [[UIImageView alloc]init];
//    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APPWidth, 0.5)];
//    line.image = imageFromBundleName(@"CommonUIModule.bundle", @"tabbar_line.png");
//    [barvw addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(@0);
//        make.height.equalTo(@1).multipliedBy(0.5);
//    }];
    
    // 加载下面的导航
//    CGFloat itemwidth = w/titles.count;
    __weak AMDTabbarItem *_lastItem = nil;
    for (NSInteger i = 0; i<titles.count; i++) {
//        AMDTabbarItem *item = [[AMDTabbarItem alloc]initWithFrame:CGRectMake(itemwidth*i, 0, itemwidth, 49)];
        AMDTabbarItem *item = [[AMDTabbarItem alloc]init];
        item.itemTitleLabel.text = titles[i];
        [item setImage:images[i] controlState:UIControlStateNormal];
        [item setTitleColor:ColorWithRGB(101, 111, 130, 1) controlState:UIControlStateNormal];
//        [item setTitleColor:tabbar_text_select_color controlState:UIControlStateSelected];
        
        item.tag = i+900;
        [item addTarget:self action:@selector(clickBt_ChangeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [barvw addSubview:item];
        [item setImage:selectimgs[i] controlState:UIControlStateSelected];
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(@0);
            if (_lastItem == nil) {
                make.left.equalTo(@0);
            }
            else {
                make.left.equalTo(_lastItem.mas_right).with.offset(0);
                make.width.equalTo(_lastItem.mas_width);
            }
            
            if (i == titles.count-1) {
                make.right.equalTo(@0);
            }
        }];
        _lastItem = item;
        
        switch (i) {
            case 0:     //进来的时候默认第一项选中
                item.selected = YES;
                break;
            default:
                break;
        }
    }
}


// 隐藏之前的tabar
-(CGRect)hideTabBar
{
    CGRect oldTabBarRect = CGRectMake(0, 0, 0, 0);
    for (UIView * v in self.view.subviews) {
        if ([v isKindOfClass:[UITabBar class]]) {
            oldTabBarRect = v.frame;
//            v.frame = CGRectMake(0, v.frame.origin.y+49, APPWidth,49);
//            v.hidden = YES;
            break;
        }
    }
    return oldTabBarRect;
}

// 支持右上角文字提示
//- (void)supportMessageRemindWithIndex:(NSInteger)index
//{
//    AMDTabbarItem *item = (AMDTabbarItem *)[_currentTabbar viewWithTag:900+index];
//    _retainItem = item;
//    [item supportMessageCountObserver];
//}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    NSLog(@"");
//    [self updateViewConstraints];
//    [self.view layoutSubviews];
}


#pragma mark - 按钮事件
- (void)clickBt_ChangeSelect:(AMDTabbarItem *)sender
{
    [self selectTabbarIndex:sender.tag-900];
}

- (void)selectTabbarIndex:(NSInteger)index
{
    if (self.selectedIndex == index) {
        
//        switch (index) {
//            case 2: //发现
//                //当前选中的是第一个动态的话--执行一次
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"AMDDiscoverIndexController" object:nil];
//                break;
//            default:
//                break;
//        }
        return;
    }
    
    //清除之前的选中状态
    AMDTabbarItem *lastitem = (AMDTabbarItem *)[self.view viewWithTag:self.selectedIndex+900];
    lastitem.selected = NO;
    
    //改变选中状态
    self.selectedIndex = index;
    
    //改变当前按钮的选中状态
    AMDTabbarItem *sender = (AMDTabbarItem *)[self.view viewWithTag:self.selectedIndex+900];
    sender.selected = YES;
    
}

// 显示新消息
/*- (void)showNewMessageCount:(NSInteger)count
{
    // 寻找当前MessageIndexController在队列中的索引值
    static NSInteger index = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (UIViewController *sender in self.viewControllers) {
            if ([sender isKindOfClass:NSClassFromString(@"AMDMessageIndexController")]) {
                index = [self.viewControllers indexOfObject:sender];
                break;
            }
        }
    });
    
    // 提示新消息
    AMDTabbarItem *sender = (AMDTabbarItem *)[self.view viewWithTag:index+900];
    [sender showMessageCount:count];
}

// 设置消息数量
- (void)setShowMessageCount:(NSInteger)count index:(NSInteger)index
{
    AMDTabbarItem *sender = (AMDTabbarItem *)[self.view viewWithTag:index+900];
    dispatch_async(kGCDMain, ^{
        [sender showMessageCount:count];
    });
}*/



@end





#pragma mark - 消息数量
@implementation AMDTabBarView

- (void)drawRect:(CGRect)rect
{
    //填充背景色
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [ColorWithRGB(246, 246, 246, 1) setFill];
    [path fill];
    
    //绘制圆弧线
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(ref, NO);      //关闭锯齿  默认情况下，锯齿显示，所以线条宽度为2.0
    CGContextSetLineWidth(ref, 0.5);
    CGContextSetStrokeColorWithColor(ref, [ColorWithRGB(195, 195, 195, 1) CGColor]);
    CGContextSetFillColorWithColor(ref, [ColorWithRGB(250, 250, 250, 1) CGColor]);
    
    // 圆弧的起点
    CGFloat appw = rect.size.width;
    CGFloat startpoint = (appw-60)/2;
    CGFloat endpoint = startpoint + 60;
    
    CGFloat offy = 14;
    CGMutablePathRef pathref = CGPathCreateMutable();
    // 第一段线
    CGPathMoveToPoint(pathref, nil, 0-1, offy-1);
    CGPathAddLineToPoint(pathref, nil, startpoint, offy-1);
    
    //圆弧
    CGPathMoveToPoint(pathref, nil, endpoint+1, offy-1);
    CGPathAddArc(pathref, nil, rect.size.width/2, 40, 40, -43*M_PI/180, -137*M_PI/180, 1);
    
    CGPathMoveToPoint(pathref, nil, endpoint, offy-1);
    
    // 第二段线
    CGPathAddLineToPoint(pathref, nil, appw+1, offy-1);
    CGPathAddLineToPoint(pathref, nil, appw+1, rect.size.height);
    CGPathAddLineToPoint(pathref, nil, 0-1, rect.size.height);
    CGPathAddLineToPoint(pathref, nil, 0-1, offy-1);
    
    CGContextAddPath(ref, pathref);
    CGPathRelease(pathref);
    // 线条和填充色
    CGContextDrawPath(ref, kCGPathFillStroke);
    
}

@end




@implementation UIViewController (AMDTabBarControllerItem)

@dynamic amdTabBarController;
@dynamic amdTabBarItem;

// 动态实现属性的SET和GET方法
- (AMDTabbarController *)amdTabBarController
{
    return (AMDTabbarController *)self.tabBarController;
}


- (AMDTabbarItem *)amdTabBarItem
{
    NSInteger index = [self.amdTabBarController.viewControllers indexOfObject:self];
    AMDTabbarItem *item = [self.amdTabBarController.amdTabBar viewWithTag:(900+index)];
    if (![item isKindOfClass:[AMDTabbarItem class]]) {
        return nil;
    }
    return item;
}





@end














