//
//  UIViewController+UINavigationBar.h
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (UINavigationBar)

@property (nonatomic, strong) NSString *navTitleString;
@property (nonatomic, strong) UIView *navTitleView;

@property (nonatomic, strong) UIColor* navBarColor;     //改变导航栏背景颜色
@property (nonatomic, strong) UIColor* navTitleColor;   //改变导航栏标题颜色
@property (nonatomic, strong) UIColor* navLeftItemNormalTitleColor;     //改变导航栏左边按钮的Normal状态标题颜色
@property (nonatomic, strong) UIColor* navRightItemNormalTitleColor;    //改变导航栏右边按钮的Normal状态标题颜色
@property (nonatomic, strong) UIColor* navItemHighlightedTitleColor;    //改变导航栏左边按钮、右边按钮的Highlighted状态标题颜色

- (void)clearNavLeftItem;
- (void)setNavLeftItemWithImage:(NSString *)image target:(id)target action:(SEL)action;
- (void)setNavLeftItemWithName:(NSString *)name target:(id)target action:(SEL)action;
- (void)setNavLeftItemWithName:(NSString *)name font:(UIFont *)font target:(id)target action:(SEL)action;

- (void)setNavRightItemWithImage:(NSString *)image target:(id)target action:(SEL)action;
- (void)setNavRightItemWithName:(NSString *)name target:(id)target action:(SEL)action;
- (void)setNavRightItemWithName:(NSString *)name font:(UIFont *)font target:(id)target action:(SEL)action;

- (void)addNavLeftItemWithImage:(NSString*)image position:(UINavigationItemPosition)position target:(id)target action:(SEL)action;
- (void)addNavLeftItemWithName:(NSString*)name position:(UINavigationItemPosition)position target:(id)target action:(SEL)action;

- (void)addNavRightItemWithImage:(NSString*)image position:(UINavigationItemPosition)position target:(id)target action:(SEL)action;
- (void)addNavRightItemWithName:(NSString*)name position:(UINavigationItemPosition)position target:(id)target action:(SEL)action;

@end
