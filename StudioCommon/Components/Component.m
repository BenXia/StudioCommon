//
//  Component.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "Component.h"
#import "ComponentPayment.h"

#pragma mark - 

Component *component = nil;

#pragma mark -

@implementation Component

@def_singleton( Component )

- (instancetype)init {
    if (self = [super init]) {
        component = self;
    }
    
    return self;
}

+ (void)powerOn {
    
}

+ (void)powerOff {
    
}

#pragma mark - 

+ (void)load {
    [Component sharedInstance];
    
    [[Component sharedInstance] loadClasses];
}

/**
 *  伪插件式思想，运行时配置，各模块
 */
- (void)loadClasses {
    const char *classes[]   = {
        // 支付
        "ComponentWechatPay",
        NULL
    };
    
    NSUInteger total   = 0;
    
    for (NSInteger i = 0;; ++i) {
        const char * classname  = classes[i];
        if (!classname) {
            break;
        }
        
        Class classtype = NSClassFromString([NSString stringWithUTF8String:classname]);
        if (classtype) {
            [classtype load];
        }
        
        total += 1;
    }
}

@end

#pragma mark - 

@def_package(Component, ComponentPayment,        payment)


