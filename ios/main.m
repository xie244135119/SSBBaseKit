//
//  main.m
//  ios
//
//  Created by SunSet on 2017/6/6.
//  Copyright © 2017年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

CFAbsoluteTime StartTime = 0;
int main(int argc, char * argv[]) {
    StartTime = CFAbsoluteTimeGetCurrent();
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
