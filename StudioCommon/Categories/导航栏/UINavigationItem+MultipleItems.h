//
//  UINavigationItem+MultipleItems
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UINavigationItemPositionLeft,
    UINavigationItemPositionRight
} UINavigationItemPosition;

@interface UINavigationItem (MultipleItems)

- (void)addLeftBarButtonItem:(UIBarButtonItem *)item atPosition:(UINavigationItemPosition)position;
- (void)addRightBarButtonItem:(UIBarButtonItem *)item atPosition:(UINavigationItemPosition)position;

- (void)removeLeftBarButtonItem:(UIBarButtonItem *)item;
- (void)removeRightBarButtonItem:(UIBarButtonItem *)item;
- (void)removeBarButtonItem:(UIBarButtonItem *)item;

@end
