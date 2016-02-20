//
//  ImageUtil.h
//  RRPT
//
//  Created by zhenjunfan on 14-8-26.
//  Copyright (c) 2014年 zhenjunfan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ImageType) {
    kImageTypePic       = 0,
    kImageTypeThird     = 1,
    kImageTypeHead      = 2,
    kImageTypeBanner    = 3,
};

typedef NS_ENUM(NSInteger, ImageSize) {
    kImageSizeSmall = 0,
    kImageSizeBig   = 1,
};

typedef NS_ENUM(NSInteger, ImageOperationType) {
    kImageOperationCrop       = 0,    //切图
    kImageOperationResize     = 1,    //等比缩放
    kImageOperationOrigin     = 2,    //原图
};

typedef NS_ENUM(NSUInteger, ImageFormat) {
    kImageFormatPNG,
    kImageFormatJPG,
    kImageFormatGIF,
};

@interface ImageUtil : NSObject

/**
 * 获取下载url接口，
 *iamge_name 图片名字
 *type 类型 NS_ENUM
 */
+ (NSURL *)imageUrl:(NSString *)imageName size:(NSInteger)size type:(NSInteger)type;

/**
 * 新版图片下载地址
 */
+ (NSString*)urlForDownloadImageWithPath:(NSString*)path
                               Operation:(ImageOperationType)opertaion
                                    Size:(CGSize)size;

/*
 * 缩放图像
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

/*
 * 等比缩放图像
 */
+ (UIImage *)scaleImage:(UIImage*)image ratio:(CGFloat)ratio;

/*
 * 等比缩放图像,指定最短边像素数
 */
+ (UIImage *)scaleImage:(UIImage*)image minSide:(CGFloat)minSide;

/*
 * 压缩图像，为上传图片用，最小边分辨率为720,控制在300K以下
 */
+ (NSData*)compressImageForUpload:(UIImage*)img;

/**
 * 对照片进行处理之前，先将照片旋转到正确的方向，并且返回的imageOrientaion为0。执行时长0.5s
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 * 对照片进行处理之前，先将照片旋转到正确的方向，并且返回的imageOrientaion为0。执行时长0.4s
 */
+ (UIImage *)fastFixOrientation:(UIImage *)aImage;


@end

#define URL_HEAD_SMALL(imagename) [ImageUtil imageUrl:imagename size:kImageSizeSmall type:kImageTypeHead]




