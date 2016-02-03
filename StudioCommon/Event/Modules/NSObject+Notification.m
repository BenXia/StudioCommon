//
//  NSObject+Notification.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "NSObject+Notification.h"

#pragma mark - NSNotification (TypeInference)

@implementation NSNotification (TypeInference)

- (BOOL)is:(NSString *)name {
    return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix {
    return [self.name hasPrefix:prefix];
}

+ (instancetype)notificationWithName:(NSString *)aName {
    return [NSNotification notificationWithName:aName object:nil];
}

@end

#pragma mark - NSObject (Notification)

@implementation NSObject (Notification)

+ (NSString *)NOTIFICATION {
    return [self NOTIFICATION_TYPE];
}

+ (NSString *)NOTIFICATION_TYPE {
    return [NSString stringWithFormat:@"notify.%@.", [self description]];
}

- (void)handleNotification:(NSNotification *)notification {
    (void) notification;
}

- (void)didReceiveNotification:(NSNotification *)notification {
    (void) notification;
}

- (void)observeNotification:(NSString *)name {
    {
        NSString * selectorName;
        SEL selector;
        
        selectorName = [NSString stringWithFormat:@"didReceiveNotification:"];
        selector = NSSelectorFromString(selectorName);
        
        if ( [self respondsToSelector:selector] ) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:selector
                                                         name:name
                                                       object:nil];
            return;
        }
    }
}

- (void)observeNotification:(NSString *)name
               withCategory:(NSString *)categoryname {
    {
        NSString * selectorName;
        SEL selector;
        
        if ([categoryname length]) {
            selectorName = [NSString stringWithFormat:@"didReceiveNotification_%@:", categoryname];
        } else {
            selectorName = [NSString stringWithFormat:@"didReceiveNotification:"];
        }
        selector = NSSelectorFromString(selectorName);
        
        if ( [self respondsToSelector:selector] ) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:selector
                                                         name:name
                                                       object:nil];
            return;
        }
    }
    
    { // General handler
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)
                                                     name:name
                                                   object:nil];
    }
}

- (void)unobserveNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)postNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    
    return YES;
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    
    return YES;
}

@end
