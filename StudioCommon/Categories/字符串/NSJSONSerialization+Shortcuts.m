//
//  NSJSONSerialization.m
//  FoundationExtension
//
//  Created by Jeong YunWon on 12. 11. 4..
//  Copyright (c) 2012 youknowone.org. All rights reserved.
//

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070 || __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000


#import "NSJSONSerialization+Shortcuts.h"

@implementation NSJSONSerialization (Shortcuts)

+ (id)JSONObjectWithString:(NSString *)string options:(NSJSONReadingOptions)opt error:(NSError **)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        return [self JSONObjectWithData:data options:opt error:error];
    } else {
        *error = [NSError errorWithDomain:@"" code:1 userInfo:nil];
        return nil;
    }
}

+ (NSString *)stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error
{
    NSData *data = [self dataWithJSONObject:obj options:opt error:error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

#endif
