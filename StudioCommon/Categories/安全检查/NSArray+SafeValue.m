//
//  NSArray+SafeValue.m
//  StudioCommon
//
//  Created by Ben on 6/10/15.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "NSArray+SafeValue.h"
#import "NSObject+SafeValueWithJSON.h"
#import "NSArray+ObjectAtIndexWithBoundsCheck.h"

@implementation NSArray (SafeValue)

- (NSString *)safeStringAtIndex:(NSUInteger)index {
    return [[self objectAtIndexIfIndexInBounds:index] safeString];
}

- (NSNumber *)safeNumberAtIndex:(NSUInteger)index {
    return [[self objectAtIndexIfIndexInBounds:index] safeNumber];
    
}

- (NSArray *)safeArrayAtIndex:(NSUInteger)index {
    return [[self objectAtIndexIfIndexInBounds:index] safeArray];
}

- (NSDictionary *)safeDictionaryAtIndex:(NSUInteger)index {
    return [[self objectAtIndexIfIndexInBounds:index] safeDictionary];
}

@end
