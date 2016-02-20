//
//  QQingPageControl.h
//  StudioCommon
//
//  Created by Ben on 8/6/15.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    show_center,
    show_left,
    show_right,
} ShowType;

@interface QQingPageControl : UIView
{
    NSMutableArray *m_pPageArray;
    NSInteger m_pageCount;
    NSInteger m_curPage;
}

@property (nonatomic) double point_img_width;
@property (nonatomic) double point_max_space;
@property (nonatomic) double point_min_space;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic) ShowType showType;

@property (nonatomic, assign, setter = setPageCount:) NSInteger m_pageCount;
@property (nonatomic, assign, setter = setCurPage:) NSInteger m_curPage;

- (id)initWithFrame:(CGRect)frame withPageCount:(NSInteger)count;
- (void)refreshPageControl;

@end
