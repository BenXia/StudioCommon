//
//  UIButton+Theme.m
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "UIButton+Theme.h"

#pragma mark -

@implementation UIView (Style)

- (void)setBorderWidth:(CGFloat)width {
    if (width) {
        self.layer.borderWidth  = width;
    }
}

- (void)setBorderColor:(UIColor *)color {
    if (color) {
        self.layer.borderColor = [color CGColor];
    }
}

// 圆角
- (void)circular:(CGFloat)dist {
    [[self layer] setCornerRadius:dist];
    [[self layer] setMasksToBounds:YES];
}

// 主题圆角：3.0
- (void)themeCircularCorner {
    [self circular:3.0f];
}

@end

#pragma mark -

@implementation UIButton (Theme)

- (void)thematized {
    [self setNormalBackgroundColor:[UIColor whiteColor]
            disableBackgroundColor:[UIColor grayColor]];

    [self setTitleColor:[UIColor whiteColor]];
    
    [self circularCorner];
}

- (void)liningThematized:(UIColor *)color {
    [self setBorderWidth:1.f withColor:color];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTitleColor:color];
    
    [self circularCorner];
}

- (void)liningThematizedWithTextColor:(UIColor *)color borderColor:(UIColor *)bordercolor {
    [self setBorderWidth:1.f withColor:bordercolor];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTitleColor:color];
    [self circularCorner];
}

- (void)colorlumpThematized:(UIColor *)color {
    [self setNormalBackgroundColor:color
            disableBackgroundColor:[UIColor buttonDisableStateColor]];
    
    [self setTitleColor:[UIColor whiteColor]];
    
    [self circularCorner];
}

- (void)thematizedWithBackgroundColor:(UIColor*)backgroundColor {
    [self setNormalBackgroundColor:backgroundColor
            disableBackgroundColor:[UIColor gray005Color]];
    [self setTitleColor:[UIColor whiteColor]];
    
    [self circularCorner];
}

- (void)circularCorner {
    [self circular:3.0f];
}

- (void)circularShape {
    [self circular:MIN(self.width, self.height) / 2];
}

- (void)circular:(CGFloat)dist {
    [[self layer] setCornerRadius:dist];
    [[self layer] setMasksToBounds:YES];
}

- (void)setBorderWidth:(CGFloat)width withColor:(UIColor *)color {
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
}

- (void)setTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateSelected];
}

- (void)setTitleColor:(UIColor *)tc backgroundColor:(UIColor *)bc {
    [self setTitleColor:tc];
    
    [self setImage:[UIImage imageWithColor:bc] forState:UIControlStateNormal];
    [self setImage:[UIImage imageWithColor:bc] forState:UIControlStateHighlighted];
}

- (void)setNormalBackgroundColor:(UIColor *)color disableBackgroundColor:(UIColor *)color2 {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:color2] forState:UIControlStateDisabled];
}

@end
