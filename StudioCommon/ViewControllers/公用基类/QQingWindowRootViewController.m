//
//  QQingWindowRootViewController.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "QQingWindowRootViewController.h"

@implementation QQingWindowRootViewController

+ (QQingWindowRootViewController *)createRootViewControllerWithStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    QQingWindowRootViewController *rootVC = [[QQingWindowRootViewController alloc] init];
    rootVC.statusBarStyleToSet = statusBarStyle;
    return rootVC;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyleToSet;
}

@end
