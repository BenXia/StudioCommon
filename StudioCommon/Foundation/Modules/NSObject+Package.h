//
//  NSObject+Package.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 

// Package

#undef	package
#define package( __parentClass, __class, __propertyName ) \
        class __class; \
        @interface __parentClass (__propertyName) \
        @property (nonatomic, readonly) __class * __propertyName; \
        @end

#undef	def_package
#define def_package( __parentClass, __class, __propertyName ) \
        implementation __parentClass (__propertyName) \
        @dynamic __propertyName; \
        - (__class *)__propertyName \
        { \
            return [__class sharedInstance]; \
        } \
        @end

#pragma mark -

@interface NSObject (Package)

@end
