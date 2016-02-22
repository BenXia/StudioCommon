//
//  macrodef.h
//  StudioCommon
//
//  Created by Ben on 1/26/15.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#ifndef StudioCommon_macrodef_h
#define StudioCommon_macrodef_h

/*!
 * @function Singleton GCD Macro
 */
#ifndef SINGLETON_GCD
#define SINGLETON_GCD(classname)                        \
\
+ (classname *)shared##classname {                      \
\
static dispatch_once_t pred;                        \
__strong static classname * shared##classname = nil;\
dispatch_once( &pred, ^{                            \
shared##classname = [[self alloc] init]; });    \
return shared##classname;                           \
}
#endif

#undef DEF_SINGLETON_GCD
#define DEF_SINGLETON_GCD SINGLETON_GCD

#undef DEC_SINGLETON
#define DEC_SINGLETON(classname) + (classname *)shared##classname;

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

#undef	singleton
#define singleton( __class ) \
property (nonatomic, readonly) __class * sharedInstance; \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;

#undef	def_singleton
#define def_singleton( __class ) \
dynamic sharedInstance; \
- (__class *)sharedInstance \
{ \
return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __strong id __singleton__ = nil; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

#define RUNLOOP_RUN_FOR_A_WHILE \
{ \
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
}

// 设备判断
#define IS_IPAD         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define VERTICAL_SCREEN_HEIGHT MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define VERTICAL_SCREEN_WIDTH  MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define IS_IPHONE_5     (IS_IPHONE && (VERTICAL_SCREEN_HEIGHT == 568.f))
#define IS_IPHONE_4     (IS_IPHONE && (VERTICAL_SCREEN_HEIGHT == 480.f))
#define IS_IPHONE_6     (IS_IPHONE && (VERTICAL_SCREEN_HEIGHT == 667.f))
#define IS_IPHONE_6P    (IS_IPHONE && (VERTICAL_SCREEN_HEIGHT == 736.f))

// 检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 系统版本
#define SYSTEM_VERSION  [[UIDevice currentDevice].systemVersion doubleValue]

// Log
#if DEBUG

#   define QQLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#   define QQLog( s, ... )

#endif

// RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r, g, b, 1.0f)

// ReactiveCocoa 定制

/**
 *  非绑定的RAC宏定义
 *
 *  @desc   RAC宏的原理是做属性关联
 *
 *  @warn   请使用对类型！
 */
#define NON_BIND_RAC(target, prop, signal) {\
RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];\
RACDisposable *subscriptionDisposable = [signal subscribeNext:^(id x) {\
target . prop = x ?: nil;\
} error:^(NSError *error) {\
[disposable dispose];\
} completed:^{\
[disposable dispose];\
}];\
[disposable addDisposable:subscriptionDisposable];\
}

// 默认目录
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_CACHE       [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// fixme: Should have domain\formatErrorDesc\filename\filelinenum
#undef ENC_ERROR
#define ENC_ERROR(pp_error, error_desc) {\
*pp_error = [NSError errorWithDomain:@"IngErrorDomain" code:-1L userInfo:\
[NSDictionary dictionaryWithObjectsAndKeys:\
error_desc, NSLocalizedDescriptionKey,\
NULL]];\
}

/**
 *
 *  设备类型宏判断，提供给需要在不同机型的设备上的布局调整
 *
 */
#define QQIPHONE_4_4S               (([UIScreen width] == 320) && ([UIScreen height] == 480))
#define QQIPHONE_5_5C_5S            (([UIScreen width] == 320) && ([UIScreen height] == 568))
#define QQIPHONEBELOW_6             ([UIScreen width] == 320)
#define QQIPHONE_6                  ([UIScreen width] == 375)
#define QQIPHONE_6P                 ([UIScreen width] == 414)

// 特殊数值

#undef UNDEFINED_STRING
#define UNDEFINED_STRING @"未定义"

#define kYuanSymbolStr   @"￥"

#endif
