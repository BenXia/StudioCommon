//
//  NSBundle+Utility.h
//  StudioCommon
//
//  Created by Ben on 15/8/5.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Utility)

+ (NSBundle *)studioCommonBundle;

+ (NSBundle *)bundleWithName:(NSString *)bundleName;

@end
