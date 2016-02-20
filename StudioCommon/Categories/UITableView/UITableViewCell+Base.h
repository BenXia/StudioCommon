//
//  UITableViewCell+Base.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Base)

+ (NSString *)identifier;
+ (UINib *)nib;
+ (CGFloat)cellHeight;

- (CGFloat)cellHeight;
- (void)setModel:(id)model;

@end
