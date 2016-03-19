//
//  CustomTabBarButton.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "CustomTabBarButton.h"

@implementation CustomTabBarButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];  // 注释这句可以取消系统按钮的高亮状态
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.titleLabel.font = self.normalTitleFont;
    } else {
        self.titleLabel.font = self.selectedTitleFont;
    }
}

@end
