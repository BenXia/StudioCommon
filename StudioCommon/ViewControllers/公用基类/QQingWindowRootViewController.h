//
//  QQingWindowRootViewController.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQingWindowRootViewController : BaseViewController

@property (nonatomic, assign) UIStatusBarStyle statusBarStyleToSet;

+ (QQingWindowRootViewController *)createRootViewControllerWithStatusBarStyle:(UIStatusBarStyle)statusBarStyle;

@end
