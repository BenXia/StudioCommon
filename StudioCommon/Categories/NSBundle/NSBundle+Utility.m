//
//  NSBundle+Utility.m
//  StudioCommon
//
//  Created by Ben on 15/8/5.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "NSBundle+Utility.h"

@implementation NSBundle (Utility)

+ (NSBundle *)studioCommonBundle {
    static NSBundle *g_commonBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_commonBundle = [NSBundle bundleWithName:@"StudioCommonBundle"];
    });
    
    return g_commonBundle;
}

+ (NSBundle *)bundleWithName:(NSString *)bundleName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

@end
