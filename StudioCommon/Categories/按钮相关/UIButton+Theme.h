//
//  UIButton+Theme.h
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>

////////////////// UIView

@interface UIView (Style)

- (void)setBorderWidth:(CGFloat)width;

- (void)setBorderColor:(UIColor *)color;

// 圆角
- (void)circular:(CGFloat)dist;

// 主题圆角：3.0
- (void)themeCircularCorner;

@end

////////////////// UIButton

@interface UIButton (Theme)

/**
 * 主题特化
 */
- (void)thematized;

- (void)liningThematized:(UIColor *)color; // 线条风格

- (void)liningThematizedWithTextColor:(UIColor *)color borderColor:(UIColor *)bordercolor;//线条和字体颜色

- (void)colorlumpThematized:(UIColor *)color; // 色块风格

/**
 * 主题特化,指定背景颜色
 */
- (void)thematizedWithBackgroundColor:(UIColor*)backgroundColor;

/**
 * 加圆角
 */
- (void)circularCorner;

- (void)circularShape; // 圆形

- (void)circular:(CGFloat)dist;

/**
 *  设置边框
 */

- (void)setBorderWidth:(CGFloat)width withColor:(UIColor *)color;

/**
 * 设置颜色
 
 * 状态：默认态、高亮态
 */

- (void)setTitleColor:(UIColor *)color;

- (void)setTitleColor:(UIColor *)tc backgroundColor:(UIColor *)bc;

/**
 * 设置背景色
 
 * 用image去实现
 */

- (void)setNormalBackgroundColor:(UIColor *)color disableBackgroundColor:(UIColor *)color2;

@end
