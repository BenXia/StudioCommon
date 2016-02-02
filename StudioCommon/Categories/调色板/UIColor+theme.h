//
//  UIColor+theme.h
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (theme)

#pragma mark - 颜色规范

// ===============================================
// 全局用色：主题色、辅助色
// ===============================================

+ (UIColor *)themeBlueColor;

+ (UIColor *)themeCyanColor;

// ===============================================
// 全局用色：灰色系

// Use 000, just because one '0', is too short.
// ===============================================
+ (UIColor *)gray000Color;
+ (UIColor *)gray001Color;
+ (UIColor *)gray002Color;
+ (UIColor *)gray003Color;
+ (UIColor *)gray004Color;
+ (UIColor *)gray005Color;
+ (UIColor *)gray006Color;
+ (UIColor *)gray007Color;

// ===============================================
// 背景用色
// ===============================================

+ (UIColor *)bgGray000Color;
+ (UIColor *)bgGray001Color;
+ (UIColor *)bgGray002Color;

// ===============================================
// 分割线用色
// ===============================================

+ (UIColor *)lineGray000Color;
+ (UIColor *)lineGray001Color;

// ===============================================
// 文字用色
// 暂时不区分 端
// ===============================================

+ (UIColor *)fontGray000Color; // gray000 white font 1
+ (UIColor *)fontGray005Color; // gray005       font 2
+ (UIColor *)fontGray006Color; // gray006       font 3
+ (UIColor *)fontGray007Color; // gray007       font 4

+ (UIColor *)fontWhiteColor;
+ (UIColor *)fontBlackColor;    // title
+ (UIColor *)fontGreenColor;    //              font 5
+ (UIColor *)fontOrangeColor;   //              font 6
+ (UIColor *)fontBlueColor;

// ===============================================
// 命名色
// ===============================================

+ (UIColor *)backGroundGrayColor;
+ (UIColor *)bottomToolBarBackgroundColor;
+ (UIColor *)cellBackgroundColor;
+ (UIColor *)topBarBackgroundColor;
+ (UIColor *)bottomBarBackgroundColor;
+ (UIColor *)viewBackgroundColor;
+ (UIColor *)frontTopBarBackgroundColor;
+ (UIColor *)buttonDisableStateColor;

@end
