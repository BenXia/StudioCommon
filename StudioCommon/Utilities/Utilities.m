//
//  Utilities.m
//  StudioCommon
//
//  Created by Ben on 1/10/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "Utilities.h"
#import <objc/message.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "POP.h"

static const NSUInteger kCoverViewTag = 99999;

@interface Utilities () <UIGestureRecognizerDelegate>

// Progress弹框
@property (nonatomic, strong) MBProgressHUD *progressHUD;

// Toast弹框
@property (nonatomic, strong) MBProgressHUD *toastProgressHUD;

// 弹出框
@property (nonatomic, strong) UIScrollView *popup;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, strong) UIView *contentHolder;
@property (nonatomic, assign) CGAffineTransform initialPopupTransform; // contentHolder
@property (nonatomic, strong) Block dismissCompletionBlock;
@property (nonatomic, assign) PopupAnimationType animationType;

@end

@implementation Utilities

SINGLETON_GCD(Utilities);

- (instancetype)init {
    if (self = [super init]) {
    }
    
    return self;
}

#pragma mark - VC Related

+ (UIViewController *)topVisibleContainerViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (UIViewController *)topVisibleChildViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    
    while ([vc isKindOfClass:[UINavigationController class]] || [vc isKindOfClass:[UITabBarController class]]) {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *)vc).topViewController;
            
            continue;
        }
        
        if ([vc isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabVC = ((UITabBarController *)vc);
            vc = [tabVC.viewControllers objectAtIndexIfIndexInBounds:tabVC.selectedIndex];
            
            continue;
        }
    }
    
    return vc;
}

#pragma mark - Progress, Toast

+ (MBProgressHUD *)showProgressHUDWithText:(NSString *)text {
    [[Utilities sharedUtilities].progressHUD hide:NO];
    if ([[UIApplication sharedApplication] keyWindow]) {
        [Utilities sharedUtilities].progressHUD = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow]];
        
        // Full screen show.
        [[[UIApplication sharedApplication] keyWindow] addSubview:[Utilities sharedUtilities].progressHUD];
        [[Utilities sharedUtilities].progressHUD bringToFront];
        
        [Utilities sharedUtilities].progressHUD.labelText = text;
        [Utilities sharedUtilities].progressHUD.mode = (text.length > 0) ? MBProgressHUDModeText : MBProgressHUDModeIndeterminate;
        [Utilities sharedUtilities].progressHUD.removeFromSuperViewOnHide = YES;
        [Utilities sharedUtilities].progressHUD.square = !(text.length > 0);
        [Utilities sharedUtilities].progressHUD.dimBackground = YES;
        [Utilities sharedUtilities].progressHUD.userInteractionEnabled = YES;
        
        [[Utilities sharedUtilities].progressHUD show:YES];
        
        [[GCDQueue mainQueue] queueBlock:^{
            [[Utilities sharedUtilities].progressHUD setNeedsDisplay];;
        }];
    }
    
    return [Utilities sharedUtilities].progressHUD;
}

+ (void)hideProgressHUD {
    [[GCDQueue mainQueue] queueBlock:^{
        [[Utilities sharedUtilities].progressHUD hide:YES];
    }];
}

+ (void)showLoadingView {
    [[GCDQueue mainQueue] queueBlock:^{
        if ([Utilities sharedUtilities].hudReference) return;
        if ([[UIApplication sharedApplication] keyWindow]) {
            [Utilities sharedUtilities].hudReference ++;
            [[Utilities sharedUtilities] setHud:[Utilities showProgressHUDWithText:nil]]; // fixme: 创建＋show，用queue方式不合适。
        }
    }];
}

+ (void)hideLoadingView {
    [[GCDQueue mainQueue] queueBlock:^{
        if ([Utilities sharedUtilities].hudReference < 0) {
            QQLog(@"Exception occurred!!! hudReference overflow!!");
            
            [Utilities sharedUtilities].hudReference = 0;
        }
        
        if (![Utilities sharedUtilities].hudReference) return;
        
        if ([Utilities sharedUtilities].hud) {
            [[Utilities sharedUtilities].hud hide:YES];
            [[Utilities sharedUtilities] setHud:nil];
            
            [Utilities sharedUtilities].hudReference --;
        }
    }];
}


+ (void)showToastWithText:(NSString *)text {
    [Utilities showToastWithText:text withImageName:nil blockUI:YES];
}

+ (void)showToastWithText:(NSString *)text withImageName:(NSString *)imageName blockUI:(BOOL)needBlockUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 方案一：使用MBProgressHUD
        [[Utilities sharedUtilities].progressHUD hide:NO];
        if ([[UIApplication sharedApplication] keyWindow]) {
            [Utilities sharedUtilities].progressHUD = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow]];
            
            // Full screen show.
            [[[UIApplication sharedApplication] keyWindow] addSubview:[Utilities sharedUtilities].progressHUD];
            [[Utilities sharedUtilities].progressHUD bringToFront];
            
            [Utilities sharedUtilities].progressHUD.labelText = text;
            if (([imageName length] > 0) && [UIImage imageNamed:imageName]) {
                [Utilities sharedUtilities].progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
                [Utilities sharedUtilities].progressHUD.mode = MBProgressHUDModeCustomView;
            } else {
                [Utilities sharedUtilities].progressHUD.mode = text.length > 0 ? MBProgressHUDModeText : MBProgressHUDModeIndeterminate;
                [Utilities sharedUtilities].progressHUD.square = !(text.length > 0);
            }
            
            [Utilities sharedUtilities].progressHUD.removeFromSuperViewOnHide = YES;
            [Utilities sharedUtilities].progressHUD.dimBackground = needBlockUI;
            [Utilities sharedUtilities].progressHUD.userInteractionEnabled = needBlockUI;
            
            [[Utilities sharedUtilities].progressHUD show:YES];
            
            [[Utilities sharedUtilities].progressHUD hide:YES afterDelay:1.5];
        }
        
        // 方案二：使用TSMessage
        //        [TSMessage setDefaultViewController:[[UIApplication sharedApplication].delegate.window rootViewController]];
        //
        //        [TSMessage showNotificationWithTitle:text//NSLocalizedString(@"Tell the user something", nil)
        //                                    subtitle:nil//NSLocalizedString(@"This is some neutral notification!", nil)
        //                                        type:TSMessageNotificationTypeMessage];
    });
}

+ (void)showAlertView:(NSString *)title :(NSString *)message :(NSString *)enterStr {
    UIAlertView *alertViewRe = [[UIAlertView alloc]
                                initWithTitle:title
                                message:message
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:enterStr,nil];
    
    [alertViewRe show];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:alertViewRe];
}

#pragma mark - 弹出框

+ (void)showPopup:(UIView *)contentView {
    [Utilities showPopup:contentView touchBackgroundHide:YES];
}

+ (void)showPopup:(UIView *)contentView touchBackgroundHide:(BOOL)hide {
    [Utilities showPopup:contentView touchBackgroundHide:hide animationType:PopupAnimationType_Normal];
}

+ (void)showPopup:(UIView *)contentView touchBackgroundHide:(BOOL)hide animationType:(PopupAnimationType)animationType {
    if (!contentView) return;
    
    Utilities *utils = [self sharedUtilities];
    
    if (utils.popup) return;
    
    utils.animationType = animationType;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // 圆角
    contentView.layer.cornerRadius = 4.f;
    contentView.layer.masksToBounds = YES;
    
    // 内容图之下
    utils.contentHolder = [[UIView alloc] initWithFrame:contentView.frame];
    utils.contentHolder.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [utils.contentHolder addSubview:contentView];
    
    // fa:
    // 配合KeyboardManager，这里使用ScrollView，会被自动识别为 遮挡的位移调整。
    utils.popup = [[UIScrollView alloc] initWithFrame:window.rootViewController.view.bounds];
    utils.popup.contentSize = CGSizeMake([UIUtils screenWidth], [UIUtils screenHeight]);
    utils.popup.showsHorizontalScrollIndicator = NO;
    utils.popup.showsVerticalScrollIndicator = NO;
    utils.popup.bounces = NO;
    utils.popup.scrollEnabled = NO;
    
    if (utils.needBlurBackgroundView) {
        // 获取截屏图，并高斯模糊
        UIImage *image = [Utilities screenshotForView:window.rootViewController.view];
        image = [image boxblurImageWithBlur:0.1];
        utils.blurView = [[UIImageView alloc] initWithImage:image];
        utils.blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        utils.blurView.alpha = 1;
        [utils.popup addSubview:utils.blurView];
    }
    
    // coverView
    utils.coverView = [[UIView alloc] initWithFrame:window.rootViewController.view.bounds];
    utils.coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    utils.coverView.backgroundColor = [UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5];
    utils.coverView.tag = kCoverViewTag;
    [utils.popup addSubview:utils.coverView];
    
    // 点触事件
    if (hide) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:[Utilities sharedUtilities] action:@selector(handleCloseAction:)];
        tapGesture.delegate = [Utilities sharedUtilities];
        [utils.coverView addGestureRecognizer:tapGesture];
    }
    
    [utils.coverView addSubview:utils.contentHolder];
    utils.contentHolder.center = CGPointMake(utils.coverView.bounds.size.width/2,
                                             utils.coverView.bounds.size.height/2);
    
    utils.popup.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [window.rootViewController.view addSubview:utils.popup];
    [utils.popup bringToFront];
    
    switch (utils.animationType) {
        case PopupAnimationType_Drop:
            [utils animateInDrop];
            break;
        case PopupAnimationType_Normal:
            [utils animateInNormal];
            break;
        default:
            break;
    }
}

+ (void)showPopupVC:(UIViewController *)popupVC {
    [Utilities sharedUtilities].popupVC = popupVC;
    [Utilities showPopup:popupVC.view];
}

+ (void)showPopupVC:(UIViewController *)popupVC touchBackgroundHide:(BOOL)hide {
    [Utilities sharedUtilities].popupVC = popupVC;
    [Utilities showPopup:popupVC.view touchBackgroundHide:hide];
}

+ (void)showPopupVC:(UIViewController *)popupVC touchBackgroundHide:(BOOL)hide animationType:(PopupAnimationType)animationType {
    [Utilities sharedUtilities].popupVC = popupVC;
    [Utilities showPopup:popupVC.view touchBackgroundHide:hide animationType:animationType];
}

+ (void)dismissPopup {
    Utilities *utils = [self sharedUtilities];
    
    if (utils.dismissCompletionBlock) {
        utils.dismissCompletionBlock();
        utils.dismissCompletionBlock = nil;
    }
    
    Block cleanBlock = ^{
        [utils.popup removeFromSuperview];
        utils.popup = nil;
        utils.blurView = nil;
        utils.contentHolder = nil;
        utils.coverView = nil;
        if (utils.popupVC) {
            utils.popupVC = nil;
        }
    };
    
    switch (utils.animationType) {
        case PopupAnimationType_Drop:
            [utils animateOutDropWithCompletionBlock:cleanBlock];
            break;
        case PopupAnimationType_Normal:
            [utils animateOutNormalWithCompletionBlock:cleanBlock];
            break;
        default:
            break;
    }
}

+ (void)removeAllLocalNotification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+ (void)makePhoneCall:(NSString *)tel {
    [AppSystem makePhonecall:tel];
}

// 检查相机权限
+ (BOOL)checkPhotoCaptureAccess {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

// 检查相册权限
+ (BOOL)checkPhotoLibraryAccess {
    if (floor(NSFoundationVersionNumber) > floor(1047.25)) { // iOS 8+
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if ((status == PHAuthorizationStatusDenied) || (status == PHAuthorizationStatusRestricted)) {
            return NO;
        } else {
            return YES;
        }
    } else {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if ((author == ALAuthorizationStatusDenied) || (author == ALAuthorizationStatusRestricted)) {
            return NO;
        } else {
            return YES;
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag != kCoverViewTag) {
        return NO;
    }
    return YES;
}

#pragma mark - 截屏相关

+ (UIImage *)screenshotForView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    image = [UIImage imageWithData:imageData];
    imageData = nil;
    
    return image;
}

#pragma mark - 旧版pop动画

- (void)animateInNormal {
    self.coverView.alpha   = 0;
    self.blurView.alpha    = 0;
    
    self.contentHolder.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.initialPopupTransform = self.contentHolder.transform;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.coverView.alpha = 1;
                         self.blurView.alpha = 1;
                         
                         self.contentHolder.transform = CGAffineTransformIdentity;
                     }];
}

- (void)animateOutNormalWithCompletionBlock:(Block)completion {
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.coverView.alpha = 0;
                         self.contentHolder.transform = self.initialPopupTransform;
                         self.blurView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         completion();
                     }];
}

#pragma mark - 新版pop动画

#define kPOPLayerPositionChanged    @"POPLayerPositionChanged"

- (void)animateInDrop {
    // 设置主体初始位置
    self.contentHolder.y    = -self.contentHolder.height;
    
    // 设置动画
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, kScreenHeight/2)];
    //弹性值
    springAnimation.springBounciness = 10.0;
    //弹性速度
    springAnimation.springSpeed = 20.0;
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        //
    };
    
    [self.contentHolder pop_addAnimation:springAnimation forKey:kPOPLayerPositionChanged];
}

- (void)animateOutDropWithCompletionBlock:(Block)completion {
    // 设置动画
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, -self.contentHolder.height)];
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        completion();
    };
    
    [self.contentHolder pop_addAnimation:springAnimation forKey:kPOPLayerPositionChanged];
}

- (void)handleCloseAction:(id)sender {
    [Utilities dismissPopup];
}

@end
