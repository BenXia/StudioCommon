//
//  CustomTabBar.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomTabBar;

@protocol CustomTabBarDelegate <NSObject>
/**
 *  工具栏按钮被选中, 记录从哪里跳转到哪里. (方便以后做相应特效)
 */
- (void)tabBar:(CustomTabBar *)tabBar selectedFrom:(NSInteger) from to:(NSInteger)to;

@end

@interface CustomTabBar : UIView

@property (nonatomic, weak) id<CustomTabBarDelegate> delegate;

@property (nonatomic, assign) CGFloat tabBarButtonOffsetY;

/**
 *  使用特定图片来创建按钮, 这样做的好处就是可扩展性. 拿到别的项目里面去也能换图片直接用
 *
 *  @param image         普通状态下的图片
 *  @param selectedImage 选中状态下的图片
 */
- (void)addButtonWithImage:(UIImage *)image
             selectedImage:(UIImage *)selectedImage
                     title:(NSString *)title
          normalTitleColor:(UIColor *)normalTitleColor
        selectedTitleColor:(UIColor *)selectedTitleColor;

@end
