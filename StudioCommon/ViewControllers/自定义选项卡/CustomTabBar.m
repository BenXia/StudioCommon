//
//  CustomTabBar.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "CustomTabBar.h"
#import "CustomTabBarButton.h"

@interface CustomTabBar ()

// 设置之前选中的按钮
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation CustomTabBar

- (void)addButtonWithImage:(UIImage *)image
             selectedImage:(UIImage *)selectedImage
                     title:(NSString *)title
          normalTitleColor:(UIColor *)normalTitleColor
        selectedTitleColor:(UIColor *)selectedTitleColor {
	CustomTabBarButton *btn = [[CustomTabBarButton alloc] init];

	[btn setImage:image forState:UIControlStateNormal];
	[btn setImage:selectedImage forState:UIControlStateSelected];
    
    NSDictionary *normalTitleTextAttributesDict = [[UITabBarItem appearance] titleTextAttributesForState:UIControlStateNormal];
    NSDictionary *selectedTitleTextAttributesDict = [[UITabBarItem appearance] titleTextAttributesForState:UIControlStateSelected];
    
    if (!normalTitleColor) {
        if ([normalTitleTextAttributesDict objectForKey:NSForegroundColorAttributeName]) {
            [btn setTitleColor:[normalTitleTextAttributesDict objectForKey:NSForegroundColorAttributeName]
                      forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:RGB(146,146,146)
                      forState:UIControlStateNormal];
        }
    } else {
        [btn setTitleColor:normalTitleColor
                  forState:UIControlStateNormal];
    }
    
    if (!selectedTitleColor) {
        if ([selectedTitleTextAttributesDict objectForKey:NSForegroundColorAttributeName]) {
            [btn setTitleColor:[normalTitleTextAttributesDict objectForKey:NSForegroundColorAttributeName]
                      forState:UIControlStateSelected];
        } else {
            [btn setTitleColor:[UIColor themeBlueColor]
                      forState:UIControlStateSelected];
        }
    } else {
        [btn setTitleColor:selectedTitleColor
                  forState:UIControlStateSelected];
    }
    
    if ([normalTitleTextAttributesDict objectForKey:NSFontAttributeName]) {
        btn.normalTitleFont = [normalTitleTextAttributesDict objectForKey:NSFontAttributeName];
        [btn setSelected:NO];
    } else {
        btn.normalTitleFont = [UIFont systemFontOfSize:14.0];
        [btn setSelected:NO];
    }
    
    if ([selectedTitleTextAttributesDict objectForKey:NSFontAttributeName]) {
        btn.selectedTitleFont = [selectedTitleTextAttributesDict objectForKey:NSFontAttributeName];
    } else {
        btn.selectedTitleFont = [UIFont systemFontOfSize:14.0];
    }
    
    if (title.length > 0) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn centerImageAndTitle];
    }

	[self addSubview:btn];

	[btn addTarget:self action:@selector(clickCustomTabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];

	// 如果是第一个按钮, 则选中(按顺序一个个添加)
	if (self.subviews.count == 1) {
		[self clickCustomTabBarButtonAction:btn];
	}
}

// 专门用来布局子视图, 别忘了调用super方法
- (void)layoutSubviews {
	[super layoutSubviews];

	int count = (int)self.subviews.count;
	for (int i = 0; i < count; i++) {
		//取得按钮
		UIButton *btn = self.subviews[i];

		btn.tag = i; //设置按钮的标记, 方便来索引当前的按钮,并跳转到相应的视图

		CGFloat x = i * self.bounds.size.width / count;
		CGFloat y = 0;
		CGFloat width = self.bounds.size.width / count;
		CGFloat height = self.bounds.size.height;
		btn.frame = CGRectMake(x, y, width, height);
	}
}

// 自定义TabBar的按钮点击事件
- (void)clickCustomTabBarButtonAction:(UIButton *)button {
	// 1.先将之前选中的按钮设置为未选中
	self.selectedBtn.selected = NO;
	// 2.再将当前按钮设置为选中
	button.selected = YES;
	// 3.最后把当前按钮赋值为之前选中的按钮
	self.selectedBtn = button;

	// 切换视图控制器的事情,应该交给controller来做
	// 最好这样写, 先判断该代理方法是否实现
	if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)]) {
		[self.delegate tabBar:self selectedFrom:self.selectedBtn.tag to:button.tag];
	}
}

@end
