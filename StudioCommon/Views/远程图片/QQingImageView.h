//
//  QQingImageView.h
//  StudioCommon
//
//  Created by Ben on 8/6/15.
//  Copyright © 2016年 StudioCommon. All rights reserved.

/*
 * 缓存使用统一的SDImageCache
 * 支持可配置的进度显示（默认显示加载进度）
 * 支持可配置的加载失败重试（默认支持重试）  建议尺寸小于80*80的图片，禁止该配置
 */

#import <UIKit/UIKit.h>

@class QQingImageView;

// 用户点击事件protocol
@protocol QQingImageViewSingleClickDelegate <NSObject>

@optional
- (void)didSingleClickImageView:(QQingImageView *)imageView;

@end

// 请求完成protocol
@protocol QQingImageViewFinishRequestDelegate <NSObject>

@optional
- (void)didFinishRequsetImageView:(QQingImageView *)imageView withState:(BOOL)yesOrNo;

@end


@interface QQingImageView : UIView 

- (id)initWithURL:(NSURL *)url defaultImageName:(NSString *)name imageSize:(CGSize)size;
- (id)initWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url withDefaultImageName:(NSString *)name;
- (id)initWithURL:(NSURL *)url imageSize:(CGSize)size;

- (void)cancelRequest;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSString *defaultImageName;
@property (nonatomic, assign) BOOL supportProgressIndicator;
@property (nonatomic, assign) BOOL supportFailRetry;

// 用户点击事件delegate
@property (nonatomic, weak) IBOutlet id<QQingImageViewSingleClickDelegate> singleClickDelegate;

// 请求完成delegate
@property (nonatomic, weak) IBOutlet id<QQingImageViewFinishRequestDelegate> finishRequestDelegate;

@end
