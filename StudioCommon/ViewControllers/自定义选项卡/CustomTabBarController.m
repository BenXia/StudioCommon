//
//  CustomTabBarController.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "CustomTabBarController.h"
#import "CustomTabBarButton.h"
#import "CustomTabBar.h"

@interface CustomTabBarController () <CustomTabBarDelegate>

@property (nonatomic, strong) CustomTabBar *customTabBarView;
@property (nonatomic, assign) BOOL isFirstEnter;

@end

@implementation CustomTabBarController

- (id)init {
    if (self = [super init]) {
        self.isFirstEnter = YES;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirstEnter) {
        self.isFirstEnter = NO;
        
        [self initCustomTabBar];
    }
}

- (void)initCustomTabBar {
    // 删除现有的tabBar
    CGRect rect = self.tabBar.bounds; //这里要用bounds来加,否则会加到下面去.看不见
    //[self.tabBar removeFromSuperview];
    
    // 测试添加自己的视图
    self.customTabBarView = [[CustomTabBar alloc] init]; //设置代理必须改掉前面的类型,不能用UIView
    if (self.tabBarBackgroundColor) {
        self.customTabBarView.backgroundColor = self.tabBarBackgroundColor;
    } else {
        self.customTabBarView.backgroundColor = RGB(251, 251, 251);
    }
    self.customTabBarView.delegate = self;
    self.customTabBarView.frame = rect;
    self.customTabBarView.tabBarButtonOffsetY = self.tabBarButtonOffsetY;
    
    // 添加到系统自带的tabBar上, 这样可以用的的事件方法. 而不必自己去写
    [self.tabBar addSubview:self.customTabBarView];
    
    // 为控制器添加按钮
    for (int i = 0; i < self.viewControllers.count; i++) {
        // 根据有多少个子视图控制器来进行添加按钮
        UIViewController *childVC = [self.viewControllers objectAtIndexIfIndexInBounds:i];
        
        UIImage *image = childVC.tabBarItem.image;
        UIImage *imageSel = childVC.tabBarItem.selectedImage;
        NSString *title = childVC.tabBarItem.title;
        UIColor *normalTitleColor = self.normalTitleColor;
        UIColor *selectedTitleColor = self.selectedTitleColor;
        
        [self.customTabBarView addButtonWithImage:image
                                    selectedImage:imageSel
                                            title:title
                                 normalTitleColor:normalTitleColor
                               selectedTitleColor:selectedTitleColor];
    }
}

- (void)setTabBarBackgroundColor:(UIColor *)tabBarBackgroundColor {
    _tabBarBackgroundColor = tabBarBackgroundColor;
    
    self.customTabBarView.backgroundColor = tabBarBackgroundColor;
}

- (void)setTabBarButtonOffsetY:(CGFloat)tabBarButtonOffsetY {
    _tabBarButtonOffsetY = tabBarButtonOffsetY;
    
    self.customTabBarView.tabBarButtonOffsetY = tabBarButtonOffsetY;
}

#pragma mark - CustomTabBarDelegate

- (void)tabBar:(CustomTabBar *)tabBar selectedFrom:(NSInteger)from to:(NSInteger)to {
	self.selectedIndex = to;
}

@end
