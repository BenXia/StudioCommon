//
//  BaseConfiguration.m
//  StudioCommon
//
//  Created by Ben on 15/7/30.
//  Copyright (c) 2015年 QQingiOSTeam. All rights reserved.
//

#import "BaseConfiguration.h"
#import "DentistConfiguration.h"
#import "TxtdConfiguration.h"
#import "TemplateProjectConfiguration.h"

@implementation BaseConfiguration

+ (BaseConfiguration *)sharedConfiguration {
    static BaseConfiguration *configurationSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
        if ([bundleID hasPrefix:@"com.toboom.yayiabc"]) {
            configurationSingleton = [DentistConfiguration new];
        } else if ([bundleID hasPrefix:@"com.toboom.txtddemo"]) {
            configurationSingleton = [TxtdConfiguration new];
        } else if ([bundleID hasPrefix:@"com.toboom.templateProject"]) {
            configurationSingleton = [TemplateProjectConfiguration new];
        } else {
#ifdef DEBUG
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出大事了"
                                                                message:@"StudioCommon配置类初始化失败了！！！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"赶紧去看看"
                                                      otherButtonTitles:nil];
            [alertView show];
#endif
            configurationSingleton = [BaseConfiguration new];
        }
    });
    
    return configurationSingleton;
}

+ (void)adapterAppDentist:(Block)blockExecuteOnDentist
                  appTxtd:(Block)blockExecuteOnTxtd
       appTemplateProject:(Block)blockExecuteOnTemplateProject {
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    if ([bundleID hasPrefix:@"com.toboom.yayiabc"]) {
        if (blockExecuteOnDentist) {
            blockExecuteOnDentist();
        }
    } else if ([bundleID hasPrefix:@"com.toboom.txtddemo"]) {
        if (blockExecuteOnTxtd) {
            blockExecuteOnTxtd();
        }
    } else if ([bundleID hasPrefix:@"com.toboom.templateProject"]) {
        if (blockExecuteOnTemplateProject) {
            blockExecuteOnTemplateProject();
        }
    } else {
#ifdef DEBUG
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"出大事了"
                                                            message:@"StudioCommon配置类初始化失败了！！！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"赶紧去看看"
                                                  otherButtonTitles:nil];
        [alertView show];
#endif
    }
}

+ (BOOL)isAppDentist {
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    return [bundleID hasPrefix:@"com.toboom.yayiabc"];
}

+ (BOOL)isAppTxtd {
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    return [bundleID hasPrefix:@"com.toboom.txtddemo"];
}

+ (BOOL)isAppTemplateProject {
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    return [bundleID hasPrefix:@"com.toboom.templateProject"];
}

#pragma mark - Overriden methods

// ===============================================
// 全局用色：主题色、辅助色
// ===============================================

- (UIColor *)themeBlueColor {
    return [UIColor colorWithRed:56.0/255 green:115.0/255 blue:181.0/255 alpha:1];
}

- (UIColor *)themeButtonBlueColor {
    return [UIColor colorWithRGBHex:0x33A7E4];
}

- (UIColor *)themeCyanColor {
    return [UIColor colorWithRed:61.0/255 green:183.0/255 blue:235.0/255 alpha:1];
}

- (UIColor *)themeLightBlueColor {
    return [UIColor colorWithRGBHex:0x617ac4];
}

- (UIColor *)themeRedColor {
    return [UIColor colorWithRGBHex:0xda2f1d];
}

- (UIColor *)themeBackGrayColor {
    return [UIColor colorWithRGBHex:0xe6e6e6];
}

- (UIColor *)themeDarkBlueColor{
    return [UIColor blueColor];
}
- (UIColor *)themeGreenColor{
    return [UIColor greenColor];
}

// ===============================================
// 全局用色：灰色系

// Use 000, just because one '0', is too short.
// ===============================================

- (UIColor *)gray000Color {
    return [UIColor colorWithRGBHex:0xffffff];
}

- (UIColor *)gray001Color {
    return [UIColor colorWithRGBHex:0xf7f7f7];
}

- (UIColor *)gray002Color {
    return [UIColor colorWithRGBHex:0xf0f0f0];
}

- (UIColor *)gray003Color {
    return [UIColor colorWithRGBHex:0xebebeb];
}

- (UIColor *)gray004Color {
    return [UIColor colorWithRGBHex:0xcccccc];
}

- (UIColor *)gray005Color {
    return [UIColor colorWithRGBHex:0x999999];
}

- (UIColor *)gray006Color {
    return [UIColor colorWithRGBHex:0x666666];
}

- (UIColor *)gray007Color {
    return [UIColor colorWithRGBHex:0x333333];
}

// ===============================================
// 背景用色
// ===============================================

- (UIColor *)bgGray000Color {
    return [UIColor colorWithRGBHex:0xffffff];
}

- (UIColor *)bgGray001Color {
    return [UIColor colorWithRGBHex:0xf7f7f7];
}

- (UIColor *)bgGray002Color {
    return [UIColor colorWithRGBHex:0xf0f0f0];
}

- (UIColor *)bgGreenColor {
    return [UIColor colorWithRGBHex:0x54ae37];
}

// ===============================================
// 分割线用色
// ===============================================

- (UIColor *)lineGray000Color {
    return [UIColor colorWithRGBHex:0xebebeb];
}

- (UIColor *)lineGray001Color {
    return [UIColor colorWithRGBHex:0xcccccc];
}

// ===============================================
// 文字用色
// ===============================================

- (UIColor *)fontGray000Color {
    return [UIColor colorWithRGBHex:0xffffff];
}

- (UIColor *)fontGray005Color {
    return [UIColor colorWithRGBHex:0x999999];
}

- (UIColor *)fontGray006Color {
    return [UIColor colorWithRGBHex:0x666666];
}

- (UIColor *)fontGray007Color {
    return [UIColor colorWithRGBHex:0x333333];
}

- (UIColor *)fontWhiteColor {
    return [UIColor colorWithRGBHex:0xffffff];
}

- (UIColor *)fontBlackColor {
    return [UIColor colorWithRGBHex:0x333333];
}

- (UIColor *)fontGreenColor {
    return [UIColor colorWithRGBHex:0x54ae37];
}

- (UIColor *)fontOrangeColor {
    return [UIColor colorWithRGBHex:0xff6600];
}

- (UIColor *)fontBlueColor {
    return [UIColor colorWithRed:56.0/255 green:115.0/255 blue:181.0/255 alpha:1];
}

- (UIColor *)fontGray_one_Color_deprecated {
    return [UIColor colorWithRGBHex:0x333333];
}

- (UIColor *)fontGray_two_Color_deprecated {
    return [UIColor colorWithRGBHex:0x666666];
}

- (UIColor *)fontGray_three_Color_deprecated {
    return [UIColor colorWithRGBHex:0x999999];
}

- (UIColor *)fontGray_four_Color_deprecated {
    return [UIColor colorWithRGBHex:0xcccccc];
}

#pragma mark - 命名色

- (UIColor *)backGroundGrayColor {
    return [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
}

- (UIColor *)bottomToolBarBackgroundColor {
    return [UIColor colorWithRGBHex:0xffffff];
}

- (UIColor *)cellBackgroundColor {
    return [UIColor colorWithRGBHex:0xffffff];
}

- (UIColor *)topBarBackgroundColor {
    return [UIColor colorWithRGBHex:0xf7f7f7];
}

- (UIColor *)bottomBarBackgroundColor {
    return [UIColor colorWithRGBHex:0xf7f7f7];
}

- (UIColor *)viewBackgroundColor {
    return [UIColor colorWithRGBHex:0xf0f0f0];
}

- (UIColor *)frontTopBarBackgroundColor {
    return [UIColor colorWithRed:56.0/255 green:115.0/255 blue:181.0/255 alpha:1];
}

- (UIColor *)buttonDisableStateColor {
    return [UIColor colorWithRGBHex:0xcccccc];
}

@end

