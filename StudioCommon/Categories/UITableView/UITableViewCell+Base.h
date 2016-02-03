//
//  UITableViewCell+Base.h
//  QQingCommon
//
//  Created by 李杰 on 9/15/15.
//  Copyright (c) 2015 QQingiOSTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Base)

+ (NSString *)identifier;
+ (UINib *)nib;
+ (CGFloat)cellHeight;

- (CGFloat)cellHeight;
- (void)setModel:(id)model;

@end
