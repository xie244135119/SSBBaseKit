//
//  SSGlobalVar.h
//  SSBaseKit
//
//  Created by SunSet on 2017/5/19.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#ifndef SSGlobalVar_h
#define SSGlobalVar_h


#define ColorWithRGB(r,g,b,a) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:a]

//字体
#define FontWithName(n,s) [UIFont fontWithName:@"HiraginoSansGB-W3" size:s]
//#define FontWithName(n,s) [UIFont systemFontOfSize:s]
#define FontBoldWithName(n,s) [UIFont fontWithName:@"HiraginoSansGB-W3" size:s]


// 从本地获取
#define GetFilePath(a) [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:a]
#define GetFilePathFromBundle(b,n) [[[NSBundle bundleWithPath:GetFilePath(b)] resourcePath]stringByAppendingPathComponent:n]
#define imageFromPath(a) [[UIImage alloc]initWithContentsOfFile:GetFilePath(a)]
#define imageFromName(a) [[UIImage alloc]initWithContentsOfFile:GetFilePath(a)]
#define imageFromBundleName(b,n) [[UIImage alloc]initWithContentsOfFile:GetFilePathFromBundle(b, n)]


// 统一配置
// 线条高度
#define SSLineHeight 0.5
// 线条颜色
#define SSLineColor ColorWithRGB(230, 230, 230, 1)
// 默认圆角
#define SSCornerRadius 3



#endif /* SSGlobalVar_h */
