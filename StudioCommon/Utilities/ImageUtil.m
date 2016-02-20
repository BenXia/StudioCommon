//
//  ImageUtil.m
//  RRPT
//
//  Created by zhenjunfan on 14-8-26.
//  Copyright (c) 2014年 zhenjunfan. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

#pragma mark - Image URL

// 0 小 1 大
+ (NSURL *)imageUrl:(NSString *)imageName size:(NSInteger)size type:(NSInteger)type {
    if (imageName.length == 0) {
        return nil;
    }
    NSRange newRange = [imageName rangeOfString:@"{0}"];
    if (newRange.location != NSNotFound) {
        NSString *imageUlr=[NSString stringWithFormat:@"%@%@",@"http://api.x.jiefangqian.com/",imageName];
      NSString *imageStr= [imageUlr stringByReplacingOccurrencesOfString:@"{0}"  withString:@""];
     return [NSURL URLWithString:imageStr];
    }else{
        return [NSURL URLWithString:[[NSString alloc]initWithFormat:@"%@?type=%zd&size=%zd&name=%@",
                                     @"http://api.x.jiefangqian.com/", type, size, imageName]];
    }
}

+ (NSString*)urlForDownloadImageWithPath:(NSString*)path
                               Operation:(ImageOperationType)opertaion
                                    Size:(CGSize)size{
    NSString* doamin = @"http://api.x.jiefangqian.com/";
    NSString* url = [NSString stringWithFormat:@"%@%@.webp",doamin,path];
    NSRange holdRange = [url rangeOfString:@"{0}"];
    CGFloat scale = [UIScreen mainScreen].scale;
    if (holdRange.location != NSNotFound) {
        if (opertaion == kImageOperationCrop) {
            // 裁剪
            NSString* opretionStr = [NSString stringWithFormat:@"cp_%dx%d/",(int)(size.width*scale),(int)(size.height*scale)];
            url =  [url stringByReplacingCharactersInRange:holdRange withString:opretionStr];
        } else if (opertaion == kImageOperationResize) {
            // 等比缩放
            NSString* opretionStr = [NSString stringWithFormat:@"rs_%dx%d/",(int)(size.width*scale),(int)(size.height*scale)];
            url =  [url stringByReplacingCharactersInRange:holdRange withString:opretionStr];
        } else if (opertaion == kImageOperationOrigin) {
            // 原图
            NSString* opretionStr = @"";
            url =  [url stringByReplacingCharactersInRange:holdRange withString:opretionStr];
        }        
    }
    return url;
}


#pragma mark - Image process

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)scaleImage:(UIImage*)image ratio:(CGFloat)ratio{
    return [ImageUtil scaleToSize:image size:CGSizeMake(image.size.width * ratio, image.size.height *ratio)];
}

/*
 * 等比缩放图像,指定最短边像素数
 */
+ (UIImage *)scaleImage:(UIImage*)image minSide:(CGFloat)minSide{
    CGFloat minImageSide = MIN(image.size.width, image.size.height) * [UIScreen mainScreen].scale;
    if (minImageSide <= minSide) {
        return image;
    }else{
        return [ImageUtil scaleImage:image ratio:minSide / minImageSide];
    }
}

+ (NSData *)JPEGCompress:(UIImage *)img rate:(float)rate {
    NSData *imageData = UIImageJPEGRepresentation(img, rate);
    return imageData;
}

+ (NSData *)PNGCompress:(UIImage *)img rate:(float)rate {
    NSData *imageData = UIImagePNGRepresentation(img);
    return imageData;
}

+ (NSData*)compressImageForUpload:(UIImage*)img{
//    UIImage* scaledImage = [ImageUtil scaleImage:img minSide:720];
    return [ImageUtil compressQualityOfImage:img];
}

+ (NSData*)compressQualityOfImage:(UIImage*)img{
    CGFloat compressRatio = 1.f;
    NSData *imageData = UIImageJPEGRepresentation(img,compressRatio);
    float originSize = (float)imageData.length;
    if(imageData.length < 300*1024){
        //<300K不在压缩（相册小图）
    }else if(imageData.length < 600*1024){
        //<600k（拍照小头像）
        compressRatio = 0.9;
        imageData = UIImageJPEGRepresentation(img,compressRatio);
    }else if(imageData.length < 2*1024*1024){
        //600K~2M（拍照大头像）
        compressRatio = 0.75;
        imageData = UIImageJPEGRepresentation(img,compressRatio);
    }else if(imageData.length < 4*1024*1024){
        //2M~4M（拍照大图）
        compressRatio = 0.2;
        imageData = UIImageJPEGRepresentation(img,compressRatio);
    }else{
        //>4M（拍照大图）
        compressRatio = 0;
        imageData = UIImageJPEGRepresentation(img,compressRatio);
    }
    DDLogInfo(@"compress image -- origin:%.3fKB final:%.3fKB ratio:%f width:%fpx height:%fpx",originSize/1024,(float)imageData.length/1024,compressRatio,img.size.width*[UIScreen mainScreen].scale,img.size.height*[UIScreen mainScreen].scale);
    
    return imageData;
}

+(UIImage*)fastFixOrientation:(UIImage *)aImage{
    UIGraphicsBeginImageContext(CGSizeMake(aImage.size.width, aImage.size.height));
    [aImage drawInRect:CGRectMake(0, 0, aImage.size.width, aImage.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


//对照片进行处理之前，先将照片旋转到正确的方向，并且返回的imageOrientaion为0。
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

@end
