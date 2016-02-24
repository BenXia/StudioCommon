//
//  UIViewController+UINavigationBar.m
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "UIViewController+UINavigationBar.h"

static const CGFloat kNavigationItemFontSize = 16.0f;

@implementation UIViewController (UINavigationBar)

#pragma mark - Getters & Setters

- (void)setNavBarColor:(UIColor *)navBarColor {
    self.navigationController.navigationBar.barTintColor = navBarColor;
}

- (UIColor*)navBarColor {
    return self.navigationController.navigationBar.barTintColor;
}

- (void)setNavTitleColor:(UIColor *)navTitleColor {
    if (!navTitleColor) {
        navTitleColor = [UIColor whiteColor];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:navTitleColor}];
    NSArray* titleLabels = [self.navigationItem.titleView allViewOfClass:[UILabel class]];
    for (UILabel* label in titleLabels) {
        label.textColor = navTitleColor;
    }
    
    NSArray* allButtons = [self.navigationItem.titleView allViewOfClass:[UIButton class]];
    for (UIButton* tmpButton in allButtons) {
        [tmpButton setTitleColor:navTitleColor forState:UIControlStateNormal];
    }
}

- (UIColor*)navTitleColor {
    UIColor* titleColor = [self.navigationController.navigationBar.titleTextAttributes objectForKey:NSForegroundColorAttributeName];
    if (titleColor == nil) {
        UILabel* titleLabel = (UILabel*)[self.navigationItem.titleView firstSubviewOfClass:[UILabel class]];
        if (titleLabel) {
            titleColor = titleLabel.textColor;
        }
    }
    return titleColor;
}

- (void)setNavLeftItemNormalTitleColor:(UIColor *)navItemTitleColor {
    for (UIBarButtonItem* item in self.navigationItem.leftBarButtonItems) {
        if (!navItemTitleColor) {
            navItemTitleColor = [UIColor whiteColor];
        }
        
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:navItemTitleColor} forState:UIControlStateNormal];
        NSArray* allButtons = [item.customView allViewOfClass:[UIButton class]];
        for (UIButton* tmpButton in allButtons) {
            [tmpButton setTitleColor:navItemTitleColor forState:UIControlStateNormal];
        }
    }
}

- (UIColor*)navLeftItemNormalTitleColor {
    NSArray* buttonItems = self.navigationItem.leftBarButtonItems;
    if (buttonItems.count > 0) {
        UIBarButtonItem* item = [buttonItems firstObject];
        return [[item titleTextAttributesForState:UIControlStateNormal] objectForKey:NSForegroundColorAttributeName];
    } else {
        return nil;
    }
}

- (void)setNavRightItemNormalTitleColor:(UIColor *)navItemTitleColor {
    for (UIBarButtonItem* item in self.navigationItem.rightBarButtonItems) {
        if (!navItemTitleColor) {
            navItemTitleColor = [UIColor whiteColor];
        }
        
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:navItemTitleColor} forState:UIControlStateNormal];
        NSArray* allButtons = [item.customView allViewOfClass:[UIButton class]];
        for (UIButton* tmpButton in allButtons) {
            [tmpButton setTitleColor:navItemTitleColor forState:UIControlStateNormal];
        }
    }
}

- (UIColor*)navRightItemNormalTitleColor {
    NSArray* buttonItems = self.navigationItem.rightBarButtonItems;
    if (buttonItems.count > 0) {
        UIBarButtonItem* item = [buttonItems firstObject];
        return [[item titleTextAttributesForState:UIControlStateNormal] objectForKey:NSForegroundColorAttributeName];
    } else {
        return nil;
    }
}

- (void)setNavItemHighlightedTitleColor:(UIColor *)navItemTitleColor {
    for (UIBarButtonItem* item in self.navigationItem.leftBarButtonItems) {
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:navItemTitleColor} forState:UIControlStateHighlighted];
        NSArray* allButtons = [item.customView allViewOfClass:[UIButton class]];
        for (UIButton* tmpButton in allButtons) {
            [tmpButton setTitleColor:navItemTitleColor forState:UIControlStateHighlighted];
        }
    }
    
    for (UIBarButtonItem* item in self.navigationItem.rightBarButtonItems) {
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:navItemTitleColor} forState:UIControlStateHighlighted];
        NSArray* allButtons = [item.customView allViewOfClass:[UIButton class]];
        for (UIButton* tmpButton in allButtons) {
            [tmpButton setTitleColor:navItemTitleColor forState:UIControlStateHighlighted];
        }
    }
    
    NSArray* titleAllButtons = [self.navigationItem.titleView allViewOfClass:[UIButton class]];
    for (UIButton* tmpButton in titleAllButtons) {
        [tmpButton setTitleColor:navItemTitleColor forState:UIControlStateHighlighted];
    }
}

- (UIColor *)navItemHighlightedTitleColor {
    NSArray* leftButtonItems = self.navigationItem.leftBarButtonItems;
    if (leftButtonItems.count > 0) {
        UIBarButtonItem* item = [leftButtonItems firstObject];
        return [[item titleTextAttributesForState:UIControlStateHighlighted] objectForKey:NSForegroundColorAttributeName];
    } else {
        NSArray* rightButtonItems = self.navigationItem.rightBarButtonItems;
        if (rightButtonItems.count > 0) {
            UIBarButtonItem* item = [rightButtonItems firstObject];
            return [[item titleTextAttributesForState:UIControlStateHighlighted] objectForKey:NSForegroundColorAttributeName];
        } else {
            return nil;
        }
    }
}

#pragma mark - Middle

- (NSString *)navTitleString {
    return self.navigationItem.title ? self.navigationItem.title : self.title;
}

- (void)setNavTitleString:(NSString *)titleString {
    //自定义标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize: 18.0];
    titleLabel.textColor = [UIColor whiteColor];//设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = titleString;
    self.navigationItem.titleView = titleLabel;
}

- (UIView *)navTitleView {
    return self.navigationItem.titleView;
}

- (void)setNavTitleView:(UIView *)view {
    [self setNavigationBarTitle:view];
}

- (void)setNavigationBarTitle:(id)content {
    if (content) {
        if ([content isKindOfClass:[NSString class]]) {
            self.navigationItem.titleView = nil;
            self.navigationItem.title = content;
        } else if ([content isKindOfClass:[UIImage class]]) {
            UIImageView * imageView = [[UIImageView alloc] initWithImage:content];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            
            self.navigationItem.titleView = imageView;
        } else if ( [content isKindOfClass:[UIView class]]) {
            UIView *view = content;
            
            view.backgroundColor = [UIColor clearColor];
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            view.autoresizesSubviews = YES;
            view.x = self.view.bounds.size.width/2;
            
            self.navigationItem.titleView = content;
        } else if ( [content isKindOfClass:[UIViewController class]]) {
            self.navigationItem.titleView = ((UIViewController *)content).view;
        }
    }
}

#pragma mark - Left
- (void)clearNavLeftItem {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self.navigationItem setLeftBarButtonItems:nil];
    } else {
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
    [self.navigationItem setHidesBackButton:YES];
}

- (void)setNavLeftItemWithImage:(NSString *)image target:(id)target action:(SEL)action {
    // 左边按钮
    UIImage *nimg = [UIImage imageNamed:image];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, nimg.size.width, nimg.size.height)];
    [btn setImage:nimg forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //navigation左右按钮位置调节
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;//此处修改到边界的距离，请自行测试
        
        if (leftButton) {
            [self.navigationItem setLeftBarButtonItems:@[negativeSeperator, leftButton]];
        } else {
            [self.navigationItem setLeftBarButtonItems:@[negativeSeperator]];
        }
    } else {
        [self.navigationItem setLeftBarButtonItem:leftButton animated:NO];
    }
}

- (void)setNavLeftItemWithButton:(UIButton*)button {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    //navigation左右按钮位置调节
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;//此处修改到边界的距离，请自行测试
        
        if (leftButton) {
            [self.navigationItem setLeftBarButtonItems:@[negativeSeperator, leftButton]];
        } else {
            [self.navigationItem setLeftBarButtonItems:@[negativeSeperator]];
        }
    } else {
        [self.navigationItem setLeftBarButtonItem:leftButton animated:NO];
    }
}

- (void)setNavRightItemWithButton:(UIButton*)button{

}

- (void)setNavLeftItemWithName:(NSString *)name target:(id)target action:(SEL)action {
    [self setNavLeftItemWithName:name font:[UIFont systemFontOfSize:kNavigationItemFontSize] target:target action:action];
}

- (void)setNavLeftItemWithName:(NSString *)name font:(UIFont *)font target:(id)target action:(SEL)action {
    NSString *leftTitle = name;
    UIFont *titleLabelFont = font;
    CGSize titleSize = [leftTitle textSizeWithFont:titleLabelFont constrainedToSize:CGSizeMake(100, 1000) lineBreakMode:NSLineBreakByWordWrapping];  //一行宽度最大为 100 高度1000
    UIButton *t = [UIButton buttonWithType:UIButtonTypeCustom];
    t.titleLabel.font = titleLabelFont;
    [t setFrame:CGRectMake(0, 0, titleSize.width, self.navigationController.navigationBar.frame.size.height)];
    [t setTitle:leftTitle forState:UIControlStateNormal];
    [t setTitleColor:[UIColor whiteColor]];
    [t addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [t setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:t];
    
    [self.navigationItem setLeftBarButtonItem:leftBtn];
}

- (void)addNavLeftItemWithImage:(NSString*)image position:(UINavigationItemPosition)position target:(id)target action:(SEL)action {
    UIImage *nimg = [UIImage imageNamed:image];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, nimg.size.width, nimg.size.height)];
    [btn setImage:nimg forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationItem addLeftBarButtonItem:leftButton atPosition:position];
}

- (void)addNavLeftItemWithName:(NSString*)name position:(UINavigationItemPosition)position target:(id)target action:(SEL)action {
    NSString *leftTitle = name;
    UIFont *titleLabelFont = [UIFont systemFontOfSize:kNavigationItemFontSize];
    CGSize titleSize = [leftTitle textSizeWithFont:titleLabelFont constrainedToSize:CGSizeMake(100, 1000) lineBreakMode:NSLineBreakByWordWrapping];  //一行宽度最大为 100 高度1000
    UIButton *t = [UIButton buttonWithType:UIButtonTypeCustom];
    t.titleLabel.font = titleLabelFont;
    [t setFrame:CGRectMake(0, 0, titleSize.width, self.navigationController.navigationBar.frame.size.height)];
    [t setTitle:leftTitle forState:UIControlStateNormal];
    [t setTitleColor:[UIColor whiteColor]];
    [t addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [t setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:t];
    
    [self.navigationItem addLeftBarButtonItem:leftBtn atPosition:position];
}

#pragma mark - Right

- (void)setNavRightItemWithImage:(NSString *)image target:(id)target action:(SEL)action {
    UIImage *nimg = [UIImage imageNamed:image];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, nimg.size.width*2, nimg.size.height*2)];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setImage:nimg forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationItem setRightBarButtonItem:rightBtn];
}

- (void)setNavRightItemWithName:(NSString *)name target:(id)target action:(SEL)action {
    [self setNavRightItemWithName:name font:[UIFont systemFontOfSize:kNavigationItemFontSize] target:target action:action];
}

- (void)setNavRightItemWithName:(NSString *)name font:(UIFont *)font target:(id)target action:(SEL)action {
    // 右边按钮
    NSString *rightTitle = name;
    UIFont *titleLabelFont = font;
    CGSize titleSize = [rightTitle textSizeWithFont:titleLabelFont constrainedToSize:CGSizeMake(100, 1000) lineBreakMode:NSLineBreakByWordWrapping];  //一行宽度最大为 100 高度1000
    UIButton *t = [UIButton buttonWithType:UIButtonTypeCustom];
    t.titleLabel.font = titleLabelFont;
    [t setFrame:CGRectMake(0, 0, titleSize.width, self.navigationController.navigationBar.frame.size.height)];
    [t setTitle:rightTitle forState:UIControlStateNormal];
    [t setTitleColor:[UIColor whiteColor]];
    [t addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [t setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:t];
    
    //navigation左右按钮位置调节
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;//此处修改到边界的距离，请自行测试
        
        if (rightBtn) {
            [self.navigationItem setRightBarButtonItems:@[negativeSeperator, rightBtn]];
        } else {
            [self.navigationItem setRightBarButtonItems:@[negativeSeperator]];
        }
    } else {
        [self.navigationItem setRightBarButtonItem:rightBtn animated:NO];
    }
}

- (void)addNavRightItemWithImage:(NSString*)image position:(UINavigationItemPosition)position target:(id)target action:(SEL)action {
    UIImage *nimg = [UIImage imageNamed:image];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, nimg.size.width, nimg.size.height)];
    [btn setImage:nimg forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationItem addRightBarButtonItem:rightBtn atPosition:position];
}

- (void)addNavRightItemWithName:(NSString*)name position:(UINavigationItemPosition)position target:(id)target action:(SEL)action {
    NSString *rightTitle = name;
    UIFont *titleLabelFont = [UIFont systemFontOfSize:kNavigationItemFontSize];
    CGSize titleSize = [rightTitle textSizeWithFont:titleLabelFont constrainedToSize:CGSizeMake(100, 1000) lineBreakMode:NSLineBreakByWordWrapping];  //一行宽度最大为 100 高度1000
    UIButton *t = [UIButton buttonWithType:UIButtonTypeCustom];
    [t setFrame:CGRectMake(0, 0, titleSize.width, self.navigationController.navigationBar.frame.size.height)];
    t.titleLabel.font = titleLabelFont;
    [t setTitle:rightTitle forState:UIControlStateNormal];
    [t setTitleColor:[UIColor whiteColor]];
    [t addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [t setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:t];
    
    [self.navigationItem addRightBarButtonItem:rightBtn atPosition:position];
}

@end


