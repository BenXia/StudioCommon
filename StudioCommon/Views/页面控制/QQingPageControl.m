//
//  QQingPageControl.m
//  StudioCommon
//
//  Created by Ben on 8/6/15.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "QQingPageControl.h"

@interface QQingPageControl()

- (void)clearAllPoint;

@end

@implementation QQingPageControl
@synthesize m_pageCount;
@synthesize m_curPage;

- (id)initWithFrame:(CGRect)frame withPageCount:(NSInteger)count {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_pageCount = count;
        m_curPage = 0;
        m_pPageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    m_pPageArray = nil;
}

#pragma mark - Methods

- (void)setPageCount:(NSInteger)count {
    if (count >= 0 && count != m_pageCount) {
        m_pageCount = count;
        [self clearAllPoint];
        [self refreshPageControl];
    }
}

- (void)setCurPage:(NSInteger)page {
    if (page < m_pageCount && page >= 0) {
        if (page < [m_pPageArray count] && page != m_curPage) {
            if (m_curPage < [m_pPageArray count]) {
                //广告可能越界
                UIImageView *lastPoint = (UIImageView *)[m_pPageArray objectAtIndex:m_curPage];
                [lastPoint setHighlighted:NO];
            }
            
            UIImageView *curPoint = (UIImageView *)[m_pPageArray objectAtIndex:page];
            [curPoint setHighlighted:YES];
            
            m_curPage = page;
        }
    }
}

- (void)refreshPageControl {
    UIImageView *tmp;
    
    CGRect rect;
    CGSize size = self.frame.size;
    CGFloat space = 0.0;
    CGFloat xLoc = 0.0;
    
    if (self.showType == show_center) {
        if (m_pageCount <= 1) {
            xLoc = (size.width - self.point_img_width)/2;
        } else {
            space = (size.width - m_pageCount * self.point_img_width)/(m_pageCount - 1); //计算点之间的间隔
            
            if (space > self.point_max_space) { //点的间隔大于设置的默认最大间隔，则点之间的间隔设置为默认最大间隔
                space = self.point_max_space;
                xLoc = ((size.width - m_pageCount * self.point_img_width - (m_pageCount - 1) * self.point_max_space))/2;
            } else if (space < self.point_min_space) { //点的间隔小于设置的默认最大间隔，则点之间的间隔设置为默认最小间隔
                space = self.point_min_space;
            }
        }
    } else if (self.showType == show_right) {
        space = (size.width - m_pageCount * self.point_img_width)/(m_pageCount - 1);
        if (space > self.point_max_space) {
            space = self.point_max_space;
        } else if (space < self.point_min_space) {
            space = self.point_min_space;
        }
    } else {
        if (m_pageCount <= 1) {
            xLoc = (size.width - self.point_img_width - self.point_max_space*2);
        } else {
            space = (size.width - m_pageCount * self.point_img_width)/(m_pageCount - 1);
            
            if (space > self.point_max_space) {
                space = self.point_max_space;
                xLoc = (size.width - m_pageCount * self.point_img_width - (m_pageCount + 1) * self.point_max_space);
            } else if (space < self.point_min_space) {
                self.point_min_space = space;
            }
        }
    }
    
    for (NSInteger i = 0; i < m_pageCount; i++) {
        tmp = [[UIImageView alloc] initWithImage:self.image
                                highlightedImage:self.highlightedImage];
        rect = tmp.frame;
        rect.size.width = self.point_img_width;
        rect.size.height = self.point_img_width;
        rect.origin.y = (size.height - self.point_img_width)/2.0;
        rect.origin.x = xLoc + i * (space + self.point_img_width);
        tmp.frame = rect;
        tmp.highlighted = (i==0);
        [m_pPageArray addObject:tmp];
        [self addSubview:tmp];
        tmp = nil;
    }
}

- (void)clearAllPoint {
    for (UIImageView *tmp in m_pPageArray) {
        [tmp removeFromSuperview];
    }
    
    [m_pPageArray removeAllObjects];
}

@end
