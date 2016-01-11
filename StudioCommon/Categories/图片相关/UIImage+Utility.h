//
//  UIImage+Utility.h
//  StudioCommon
//
//  Created by Ben on 1/10/16.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

- (UIImage *)resizeImageToWidth:(CGFloat)resizedWidth height:(CGFloat)resizedHeight;

- (UIImage *)compressImageWithJPGCompression:(CGFloat)compressValue;    //return image as JPEG. May return nil if image has no CGImageRef or invalid bitmap format. compression is 0(most)..1(least)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIImage *)circleImageWithColor:(UIColor *)color andSize:(CGSize)size;

@end
