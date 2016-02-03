//
//  UIView+Hierarchy.h
//  StudioCommon
//
//  Created by Ben on 1/10/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Hierarchy)

- (NSUInteger)getSubviewIndex;

- (void)bringToFront;
- (void)sendToBack;

- (void)bringOneLevelUp;
- (void)sendOneLevelDown;

- (BOOL)isInFront;
- (BOOL)isAtBack;

- (void)swapDepthsWithView:(UIView*)swapView;

- (void)removeAllSubviews;
- (void)removeSubViewByTag:(NSUInteger)tag;
- (void)removeSubViews:(NSArray *)views;

- (BOOL)containsSubView:(UIView *)subView;
- (BOOL)containsSubViewOfClassType:(Class)classt;

//按类型取第一个子视图（所有层次，深度优先，不包含自身）
-(UIView*)firstSubviewOfClass:(Class)classObj;

//按类型过滤所有视图（所有层次，深度优先，包含自身）
-(NSMutableArray*)allViewOfClass:(Class)viewClass;

-(UIViewController*)firstTopViewController;

@end
