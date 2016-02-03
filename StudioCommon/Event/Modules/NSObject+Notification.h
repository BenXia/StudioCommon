//
//  NSObject+Notification.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotification (TypeInference)

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;

+ (instancetype)notificationWithName:(NSString *)aName;

@end

@interface NSObject (Notification)

+ (NSString *)NOTIFICATION;
+ (NSString *)NOTIFICATION_TYPE;

- (void)handleNotification:(NSNotification *)notification;

// another handler
- (void)didReceiveNotification:(NSNotification *)notification;

- (void)observeNotification:(NSString *)name;
- (void)observeNotification:(NSString *)name withCategory:(NSString *)categoryname;

- (void)unobserveNotification:(NSString *)name;
- (void)unobserveAllNotifications;

- (BOOL)postNotification:(NSString *)name;
- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

@end
