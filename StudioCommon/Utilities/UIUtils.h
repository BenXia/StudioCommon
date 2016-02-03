//
//  UIUtils.h
//  StudioCommon
//
//  Created by Ben on 1/10/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Color
//=========================
//  颜色定义
//=========================

#pragma mark - Distance + Font size

//=========================
//  边距基础定义
//=========================

#define PIXEL_2     2.f
#define PIXEL_4     4.f
#define PIXEL_8     8.f
#define PIXEL_12    12.f
#define PIXEL_16    16.f
#define PIXEL_24    24.f
#define PIXEL_36    36.f
#define PIXEL_40    40.f
#define PIXEL_48    48.f
#define PIXEL_56    56.f

//=========================
// 底边栏的按钮

//  主级按钮：整行1按钮
//  次级按钮：整行2按钮

// 只举例了，挂在下面，单一的大按钮的样式，其他各自VC中定义：
// const static CGFloat kXXXXXXXX   = ....;
//=========================

#define kDefaultButtonMargin            PIXEL_12    // 上下左右边距都是它

#define kMajorButtonHeight              PIXEL_48
#define kMinorButtonHeight              PIXEL_36

#define kMajorButtonFontSize            18.f
#define kMinorButtonFontSize            15.f

//=========================
// 分割线
//=========================

#define kDefaultSeperatorWidth          0.5f // 0.5f 也是 系统导航栏 下部边线的宽度
#define kDefaultBorderWidth             0.5f

//=========================
// 字体大小   预定义（暂不用语义，不易于一致性理解）
//=========================
#define POUND_9                         9.f// 24, PS 大小
#define POUND_14                        14.f// 36
#define POUND_15                        15.f// 40
#define POUND_18                        18.f// 48
#define POUND_23                        23.f// 60

// system font
#define FONT_9                          [UIFont systemFontOfSize:POUND_9]
#define FONT_14                         [UIFont systemFontOfSize:POUND_14]
#define FONT_15                         [UIFont systemFontOfSize:POUND_15]
#define FONT_18                         [UIFont systemFontOfSize:POUND_18]
#define FONT_23                         [UIFont systemFontOfSize:POUND_23]

//=========================
// 其他，请看标注图
//=========================

#pragma mark - UIUtils

@interface UIUtils : NSObject

/**
 * 设置视图风格，阴影
 */
+ (void)setViewStyle:(UIView *)view;

/**
 * 将view的边角磨圆, 上面可以废弃
 */
+ (void)viewWithCorner:(UIView *)view withRadius:(CGFloat)radius;

/**
 *  设置Button风格
 */
+ (void)setButtonStyle:(UIButton *)btn andColor:(UIColor *)color;

+ (void)setButtonStyleBackgroundColor:(UIButton *)btn andColor:(UIColor *)color;
/**
 * 状态栏高度
 */
+ (CGFloat)statusHeight;

/**
 * 导航栏高度
 */
+ (CGFloat)navigationBarHeight;

/**
 * tabbar高度
 */
+ (CGFloat)tabBarHeight;

/**
 * 键盘高度
 */
+ (CGFloat)keyboardHeightFromNotificationUserInfo:(NSDictionary *)userInfo;

/**
 * 屏幕高度
 */
+ (CGFloat)screenHeight;

/**
 * 屏幕宽度
 */
+ (CGFloat)screenWidth;

/**
 * 创建普通label
 
 * 默认左对齐
 * 默认单行
 */
+ (UILabel *)labelWith:(NSString *)text size:(CGFloat)size color:(UIColor *)color;
/**
 *  计算文字高度
 */
+ (float)textSizeWithFont:(UIFont *)font andTextString:(NSString *)text andSize:(CGSize)size;

#pragma mark - 

+ (void)showAlertView:(NSString*)title :(NSString*)message :(NSString*)enterStr;

@end

#pragma mark - Easy use of UIUtils

#define kStatusBarHeight            [UIUtils statusHeight]
#define kNavigationBarHeight        [UIUtils navigationBarHeight]
#define kTabBarHeight               [UIUtils tabBarHeight]

#define kScreenWidth                [UIUtils screenWidth]
#define kScreenHeight               [UIUtils screenHeight]

