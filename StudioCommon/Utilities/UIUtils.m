//
//  UIUtils.m
//  StudioCommon
//
//  Created by Ben on 1/10/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "UIUtils.h"

@implementation UIUtils

+ (void)viewWithCorner:(UIView *)view withRadius:(CGFloat)radius {
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

+ (CGFloat)statusHeight {
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    return rectStatus.size.height;
}

+ (CGFloat)navigationBarHeight {
    UINavigationController *vc =[UINavigationController new];
    CGRect rectNav = [vc.navigationBar frame];
    return rectNav.size.height;
}

+ (CGFloat)tabBarHeight {
    UITabBarController *vc = [UITabBarController new];
    CGRect rectTab = [vc.tabBar frame];
    return rectTab.size.height;
}

+ (CGFloat)keyboardHeightFromNotificationUserInfo:(NSDictionary *)userInfo {
    CGFloat currentKeyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
#ifdef __IPHONE_8_0
    //以下代码主要是为了让iOS8SDK＋iOS8之后的设备得到的键盘尺寸与iOS8SDK之前的计算方法保持一致
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
        && UIDeviceOrientationIsLandscape((UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation)) {
        currentKeyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.width;
    }
#endif
    
    return currentKeyboardHeight;
}

+ (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGFloat)screenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (UILabel *)labelWith:(NSString *)text size:(CGFloat)size color:(UIColor *)color {
    UILabel *lbl = [[UILabel alloc] init];
    
    // fixme 应该自动计算长宽
    lbl.font = [UIFont systemFontOfSize:size];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = color;
    lbl.numberOfLines = 0;
    lbl.lineBreakMode = NSLineBreakByCharWrapping;
    lbl.text = text;
    
    CGSize contentSize = [text textSizeWithFont:lbl.font
                              constrainedToSize:CGSizeZero
                                  lineBreakMode:NSLineBreakByWordWrapping];
    lbl.width = contentSize.width;
    lbl.height = contentSize.height;
    
    return lbl;
}

+ (void)setViewStyle:(UIView*)view {
    if (!view) {
        return;
    }
    view.layer.borderColor = [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:.1].CGColor;
    view.layer.borderWidth = 1;
}

+ (void)setButtonStyle:(UIButton *)btn andColor:(UIColor *)color{
    btn.layer.cornerRadius = 4.0;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = color.CGColor;
    btn.layer.borderWidth = 1;
    [btn setTitleColor:color forState:UIControlStateNormal];
}

+ (void)setButtonStyleBackgroundColor:(UIButton *)btn andColor:(UIColor *)color {
    btn.layer.cornerRadius = 4.0;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
}

+ (float)textSizeWithFont:(UIFont *)font andTextString:(NSString *)text andSize:(CGSize)size {
    NSRange allRange = [text rangeOfString:text];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];

    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect Size = [attrStr boundingRectWithSize:size
                                               options:options
                                               context:nil];
    float Height = ceilf(Size.size.height);
    return Height;
}

#pragma mark - UIView show

+ (void)showAlertView:(NSString*)title :(NSString*)message :(NSString*)enterStr {
    
    UIAlertView *alertViewRe = [[UIAlertView alloc]
                                initWithTitle:title
                                message:message
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:enterStr,nil];
    
    [alertViewRe show];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:alertViewRe];
}

@end
