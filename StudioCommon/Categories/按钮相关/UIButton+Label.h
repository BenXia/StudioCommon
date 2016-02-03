//
//  UIButton+Label.h
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Label)

- (NSString *)getLabelText;

- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;

@end
