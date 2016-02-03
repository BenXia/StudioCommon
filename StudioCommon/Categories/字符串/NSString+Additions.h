//
//  NSString+Additions.h
//  StudioCommon
//
//  Created by Ben on 1/10/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSString (Web) 

@property (nonatomic, readonly) NSString* md5Hash;

+ (NSString *)encodeURIComponent:(NSString *)string;

- (NSString *)URLEncodedString;

- (NSString *)URLEncodedStringWithSpaceToPlus;

- (NSString *)URLDecodedString;

- (NSString *)base64EncodedString;

- (NSString *)PPTVBase64Encoding;
- (NSString *)PPTVBase64Decoding;

- (NSString*)stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query;
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;

- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding;

@end


@interface NSString (PP_DateTime)

- (NSString *)handleTime;

@end


@interface NSString (PP_MultiLineHeight)

- (CGFloat)pp_boundFrameHeightWithMaxSize:(CGSize)maxSize andFont:(UIFont *)font;
- (CGFloat)pp_boundFrameWidthWithMaxSize:(CGSize)maxSize andFont:(UIFont *)font;

@end
