//
//  NSURL+PPUtils.h
//  StudioCommon
//
//  Created by Ben on 5/7/15.
//  Copyright (c) 2015 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Additions)

+ (NSString *)userAgent;

- (NSDictionary *)queryDictionary;

+ (NSDictionary *)parseURLQueryString:(NSString *)queryString;

+ (NSURL *)smartURLForString:(NSString *)str;

@end
