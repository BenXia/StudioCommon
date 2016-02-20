//
//  QQingPhotosBrowserVC.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOPhotoGlobal.h"

#define kTagOfQQingPhotosBrowserVCView 9999

@protocol QQingPhotosBrowserVCDelegate;

@interface QQingPhotosBrowserVC : BaseViewController

@property (nonatomic, weak) id<QQingPhotosBrowserVCDelegate> delegate;
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) BOOL isEditMode;
@property (nonatomic, assign) BOOL isOnlyShowImage;

- (id)initWithPhotoSource:(id <EGOPhotoSource>)aPhotoSource;
- (id)initWithPhoto:(id<EGOPhoto>)aPhoto;
- (id)initWithImage:(UIImage*)anImage;
- (id)initWithImageURL:(NSURL*)anImageURL;

- (void)showWithImageView:(QQingImageView *)imageView withCompletion:(Block)completeBlock;
- (IBAction)closeAction:(id)sender;

@end

@protocol QQingPhotosBrowserVCDelegate <NSObject>

@optional
- (void)willCloseVCWithPhotoSource:(id <EGOPhotoSource>)aPhotoSource;
- (BOOL)shouldShowOpenAnimation;  // 默认为YES
- (BOOL)shouldShowCloseAnimation; // 默认为NO
- (UIView *)imageViewContentViewForCloseAnimation;
- (NSInteger)imageViewTagOffsetForCloseAnimation;
- (void)setStatusBarHidden:(BOOL)statusBarHidden;

@end
