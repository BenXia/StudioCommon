//
//  UIColor+theme.m
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//
//

#import "UIColor+theme.h"
#import "UIColor-Expanded.h"

@implementation UIColor (theme)

// ===============================================
// 全局用色：主题色、辅助色
// ===============================================

+ (UIColor *)themeBlueColor {
    return [UIColor colorWithRed:56.0/255 green:115.0/255 blue:181.0/255 alpha:1];
}

+ (UIColor *)themeCyanColor {
    return [UIColor colorWithRed:61.0/255 green:183.0/255 blue:235.0/255 alpha:1];
}

// ===============================================
// 全局用色：灰色系

// Use 000, just because one '0', is too short.
// ===============================================

+ (UIColor *)gray000Color {
    return [UIColor colorWithRGBHex:0xffffff];
}

+ (UIColor *)gray001Color {
    return [UIColor colorWithRGBHex:0xf7f7f7];
}

+ (UIColor *)gray002Color {
    return [UIColor colorWithRGBHex:0xf0f0f0];
}

+ (UIColor *)gray003Color {
    return [UIColor colorWithRGBHex:0xebebeb];
}

+ (UIColor *)gray004Color {
    return [UIColor colorWithRGBHex:0xcccccc];
}

+ (UIColor *)gray005Color {
    return [UIColor colorWithRGBHex:0x999999];
}

+ (UIColor *)gray006Color {
    return [UIColor colorWithRGBHex:0x666666];
}

+ (UIColor *)gray007Color {
    return [UIColor colorWithRGBHex:0x333333];
}

// ===============================================
// 背景用色
// ===============================================

+ (UIColor *)bgGray000Color {
    return [UIColor colorWithRGBHex:0xffffff];
}

+ (UIColor *)bgGray001Color {
    return [UIColor colorWithRGBHex:0xf7f7f7];
}

+ (UIColor *)bgGray002Color {
    return [UIColor colorWithRGBHex:0xf0f0f0];
}

+ (UIColor *)bgGreenColor {
    return [UIColor colorWithRGBHex:0x54ae37];
}

// ===============================================
// 分割线用色
// ===============================================

+ (UIColor *)lineGray000Color {
    return [UIColor colorWithRGBHex:0xebebeb];
}

+ (UIColor *)lineGray001Color {
    return [UIColor colorWithRGBHex:0xcccccc];
}

// ===============================================
// 文字用色
// ===============================================

+ (UIColor *)fontGray000Color {
    return [UIColor colorWithRGBHex:0xffffff];
}

+ (UIColor *)fontGray005Color {
    return [UIColor gray005Color];
}

+ (UIColor *)fontGray006Color {
    return [UIColor gray006Color];
}

+ (UIColor *)fontGray007Color {
    return [UIColor gray007Color];
}

+ (UIColor *)fontWhiteColor {
    return [UIColor gray000Color];
}

+ (UIColor *)fontBlackColor {
    return [UIColor colorWithRGBHex:0x333333];
}

+ (UIColor *)fontGreenColor {
    return [UIColor colorWithRGBHex:0x54ae37];
}

+ (UIColor *)fontOrangeColor {
    return [UIColor colorWithRGBHex:0xff6600];
}

+ (UIColor *)fontBlueColor {
    return [UIColor themeBlueColor];
}

+ (UIColor *)fontGray_one_Color_deprecated {
    return [UIColor gray007Color];
}

+ (UIColor *)fontGray_two_Color_deprecated {
    return [UIColor gray006Color];
}

+ (UIColor *)fontGray_three_Color_deprecated {
    return [UIColor gray005Color];
}
+ (UIColor *)fontGray_four_Color_deprecated {
    return [UIColor gray004Color];
}

#pragma mark - 命名色

+ (UIColor *)backGroundGrayColor {
    return [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
}

+ (UIColor *)bottomToolBarBackgroundColor {
    return [UIColor gray000Color];
}

+ (UIColor *)cellBackgroundColor {
    return [UIColor gray000Color];
}

+ (UIColor *)topBarBackgroundColor {
    return [UIColor gray001Color];
}

+ (UIColor *)bottomBarBackgroundColor {
    return [UIColor gray001Color];
}

+ (UIColor *)viewBackgroundColor {
    return [UIColor gray002Color];
}

+ (UIColor *)frontTopBarBackgroundColor {
    return [UIColor themeBlueColor];
}

+ (UIColor *)buttonDisableStateColor {
    return [UIColor gray004Color];
}

@end

