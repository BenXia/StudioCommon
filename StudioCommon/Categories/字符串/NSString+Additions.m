//
//  NSString+Additions.m
//  TuanGouForZuiTu
//
//  Created by Qian GuoQiang on 10-10-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+Additions.h"
#import "NSDate+Utilities.h"

@implementation NSString (Web)

- (NSString *)PPTVBase64Decoding
{
    NSData *encodeStrData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *stringData = [encodeStrData base64Decoded];
    NSUInteger stringLength = [stringData length];
    unsigned char *stringBytes = (unsigned char *)[stringData bytes];
    
    NSString* keyString = @"pplive";
    NSData* keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger keyLength = [keyData length];
    unsigned char *keyBytes = (unsigned char *)[keyData bytes];
    
    for (int i = 0; i < stringLength; i++) {
        stringBytes[i] = (unsigned char)((int)stringBytes[i] - (int)keyBytes[i % keyLength]);
    }
    
    NSString *decodeStr = [NSString stringWithUTF8String:(const char *)stringBytes];
    
    return decodeStr;
}

- (NSString *)PPTVBase64Encoding
{
    NSData* stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSUInteger stringLength = [stringData length];
    unsigned char *stringBytes = (unsigned char *)[stringData bytes];
    
    NSString* keyString = @"pplive";
	NSData* keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
	NSUInteger keyLength = [keyData length];
    unsigned char *keyBytes = (unsigned char *)[keyData bytes];
    
    for (int i = 0; i < stringLength; i ++) {
		stringBytes[i] = (unsigned char)((int)stringBytes[i] + (int)keyBytes[i % keyLength]);
	}
    
    NSData* decodeStringData = [NSData dataWithBytes:stringBytes
											  length:stringLength];
    
    
	return [decodeStringData base64Encoding];
}

- (NSString*)md5Hash {
	NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
	
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([data bytes], (CC_LONG)[data length], result);
	
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

+ (NSString *)encodeURIComponent:(NSString *)string
{
    if ([string length] == 0)
    {
        return nil;
    }
    
	CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
																			 (CFStringRef)string,NULL,
																			 (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
																			 kCFStringEncodingUTF8);
	
	NSString *urlEncoded = nil;
    
    if (cfUrlEncodedString != NULL) {
        urlEncoded = [NSString stringWithString:CFBridgingRelease(cfUrlEncodedString)];
    }
		
	return urlEncoded;
}

- (NSString *)URLEncodedString
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
	return result;
}

// Convert space to +
- (NSString *)URLEncodedStringWithSpaceToPlus
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 CFSTR(" "),
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8));
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	return result;
}

- (NSString*)URLDecodedString
{
	NSString *result = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8));
	return result;
}

- (NSString *)base64EncodedString {

    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [query keyEnumerator]) {
        NSString* value = [query objectForKey:key];
        value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }
    
    NSString* params = [pairs componentsJoinedByString:@"&"];
    if ([self rangeOfString:@"?"].location == NSNotFound) {
        return [self stringByAppendingFormat:@"?%@", params];
        
    } else {
        return [self stringByAppendingFormat:@"&%@", params];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingURLEncodedQueryDictionary:(NSDictionary*)query {
    NSMutableDictionary* encodedQuery = [NSMutableDictionary dictionaryWithCapacity:[query count]];
    
    for (NSString* key in [query keyEnumerator]) {
        NSString* value = [query objectForKey:key];
        [encodedQuery setValue:[value URLEncodedString] forKey:[key URLEncodedString]];
    }
    
    return [self stringByAddingQueryDictionary:encodedQuery];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Copied and pasted from http://www.mail-archive.com/cocoa-dev@lists.apple.com/msg28175.html
 * Deprecated
 */
- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 1 || kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSMutableArray* values = [pairs objectForKey:key];
            if (nil == values) {
                values = [NSMutableArray array];
                [pairs setObject:values forKey:key];
            }
            if (kvPair.count == 1) {
                [values addObject:[NSNull null]];
                
            } else if (kvPair.count == 2) {
                NSString* value = [[kvPair objectAtIndex:1]
                                   stringByReplacingPercentEscapesUsingEncoding:encoding];
                [values addObject:value];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}

@end


@implementation NSString (PP_DateTime)

- (NSString *)handleTime
{
    NSString *str = nil;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue] / 1000];
    
    if ([date isToday]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        str = [NSString stringWithFormat:@"今天 %@", [formatter stringFromDate:date]];
    } else if ([date isYesterday]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        str = [NSString stringWithFormat:@"昨天 %@", [formatter stringFromDate:date]];
    } else if ([date isThisWeek]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEEE HH:mm:ss"];
        
        NSLocale *currentLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        [formatter setLocale:currentLocal];
        str = [formatter stringFromDate:date];
    } else {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        str = [formatter stringFromDate:date];
    }
    
    return str;
}

@end


@implementation NSString (PP_MultiLineHeight)

- (CGFloat)pp_boundFrameHeightWithMaxSize:(CGSize)maxSize andFont:(UIFont *)font
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    if ([self length] > 0) {
        return [self boundingRectWithSize:maxSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font}
                                  context:NULL].size.height;
    } else {
        return 0.f;
    }
#else
    if ([self length] > 0) {
        return [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping].height;
    } else {
        return 0.f;
    }
#endif
}


- (CGFloat)pp_boundFrameWidthWithMaxSize:(CGSize)maxSize andFont:(UIFont *)font
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    if ([self length] > 0) {
        return [self boundingRectWithSize:maxSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font}
                                  context:NULL].size.width;
    } else {
        return 0.f;
    }
#else
    if ([self length] > 0) {
        return [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping].width;
    } else {
        return 0.f;
    }
#endif
}
@end
