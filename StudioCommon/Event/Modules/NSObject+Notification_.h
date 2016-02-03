//
//  NSObject+Notification_.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+Property_.h"

#pragma mark -

#undef	notification
#define notification( name ) \
static_property( name )

#undef	def_notification
#define def_notification( name ) \
def_static_property2( name, @"notification", NSStringFromClass([self class]) )

#undef	def_notification_alias
#define def_notification_alias( name, alias ) \
alias_static_property( name, alias )

#undef	makeNotification
#define	makeNotification( ... ) \
macro_string( macro_join(notification, __VA_ARGS__) )

#undef	handleNotification
#define	handleNotification( ... ) \
- (void) macro_join( handleNotification, __VA_ARGS__):(NSNotification *)notification

#pragma mark -


@interface NSObject (Notification_)

@end
