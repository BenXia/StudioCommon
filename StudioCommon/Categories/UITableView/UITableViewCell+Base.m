//
//  UITableViewCell+Base.m
//  QQingCommon
//
//  Created by 李杰 on 9/15/15.
//  Copyright (c) 2015 QQingiOSTeam. All rights reserved.
//

#import "UITableViewCell+Base.h"

@implementation UITableViewCell (Base)

#pragma mark - Class

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

+ (UINib *)nib {
    return [UINib nibWithNibName:[self identifier] bundle:nil];
}

+ (CGFloat)cellHeight {
    return 0.f;
}

#pragma mark - Object

- (CGFloat)cellHeight {
    return 0.f;
}

- (void)setModel:(id)model {
    // do nothing.
}

@end
