//
//  Utilities.h
//  StudioCommon
//
//  Created by Ben on 1/10/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PopupAnimationType) {
    PopupAnimationType_Normal,     //正常弹出
    PopupAnimationType_Drop,       //下落, 默认效果
    PopupAnimationType_Default = PopupAnimationType_Normal,    //默认效果
};

@interface Utilities : NSObject

DEC_SINGLETON( Utilities )

@property (nonatomic, assign) BOOL needBlurBackgroundView;
@property (nonatomic, strong) UIViewController *popupVC;

// VC Related
+ (UIViewController *)topVisibleContainerViewController;
+ (UIViewController *)topVisibleChildViewController;

// 菊花
+ (MBProgressHUD *)showProgressHUDWithText:(NSString *)text;
+ (void)hideProgressHUD;

@property (nonatomic, assign) NSInteger hudReference;
@property (nonatomic, strong) MBProgressHUD *hud;
+ (void)showLoadingView;
+ (void)hideLoadingView;

// Toast
+ (void)showToastWithText:(NSString *)text;
+ (void)showToastWithText:(NSString *)text withImageName:(NSString *)imageName blockUI:(BOOL)needBlockUI;

// AlertView
+ (void)showAlertView:(NSString*)title :(NSString*)message :(NSString*)enterStr;

+ (void)showPopup:(UIView *)contentView;
+ (void)showPopup:(UIView *)contentView touchBackgroundHide:(BOOL)hide;
+ (void)showPopup:(UIView *)contentView touchBackgroundHide:(BOOL)hide animationType:(PopupAnimationType)animationType;
+ (void)showPopupVC:(UIViewController *)popupVC;
+ (void)showPopupVC:(UIViewController *)popupVC touchBackgroundHide:(BOOL)hide;
+ (void)showPopupVC:(UIViewController *)popupVC touchBackgroundHide:(BOOL)hide animationType:(PopupAnimationType)animationType;
+ (void)dismissPopup;

// 本地通知
+ (void)removeAllLocalNotification;

/**
 * 系统工具
 */
+ (void)makePhoneCall:(NSString *)tel;

// 检查相机权限
+ (BOOL)checkPhotoCaptureAccess;

// 检查相册权限
+ (BOOL)checkPhotoLibraryAccess;

// ScreenShoot
+ (UIImage *)screenshotForView:(UIView *)view;

@end
