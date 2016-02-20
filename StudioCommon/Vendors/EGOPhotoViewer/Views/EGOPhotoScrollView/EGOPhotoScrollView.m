 //
//  EGOPhotoScrollView.m
//  EGOPhotoViewer
//
//  Created by Devin Doty on 1/13/2010.
//  Copyright (c) 2008-2009 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOPhotoScrollView.h"

@implementation EGOPhotoScrollView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.scrollEnabled = YES;
		self.pagingEnabled = NO;
		self.clipsToBounds = NO;
		self.maximumZoomScale = 10.0f;
		self.minimumZoomScale = 1.0f;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.alwaysBounceVertical = NO;
		self.alwaysBounceHorizontal = NO;
		self.bouncesZoom = YES;
		self.bounces = YES;
		self.scrollsToTop = NO;
		self.backgroundColor = [UIColor clearColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		
    }
    return self;
}

- (void)zoomRectWithCenter:(CGPoint)center{
	
	if (self.zoomScale > 1.0f) {

		[((EGOPhotoImageView*)self.superview) killScrollViewZoom];
	
		return;
	}
    
    //得到左右,上下空白区域的宽高
	CGFloat borderX = self.frame.origin.x;
	CGFloat borderY = self.frame.origin.y;

    //第一步:调整rectToZoom区域保证完全在self.frame内部区域
	CGRect rectToZoom;
	rectToZoom.size = CGSizeMake(self.frame.size.width / EGOPV_ZOOM_SCALE, self.frame.size.height / EGOPV_ZOOM_SCALE);
	rectToZoom.origin.x = MAX((center.x - (rectToZoom.size.width / 2.0f)), 0.0f);		
	rectToZoom.origin.y = MAX((center.y - (rectToZoom.size.height / 2.0f)), 0.0f);
    if (borderX > 0.0f && (CGRectGetMaxX(rectToZoom) > self.frame.size.width)) {
        rectToZoom.origin.x = self.frame.size.width - rectToZoom.size.width;
    }
    if (borderY > 0.0f && (CGRectGetMaxY(rectToZoom) > self.frame.size.height)) {
        rectToZoom.origin.y = self.frame.size.height - rectToZoom.size.height;
    }
	
    //第二步:考虑太靠左右或上下时，放大后左右方和上下方有空白区域的偏移问题
    //Case 2.1:图片放大指定倍数后，宽高可以覆盖整个屏幕(即超过EGPPhotoImageView的宽高)，左右方或上下方则不应该再出现空白区域
    if ((borderX > 0.0f) && (self.frame.size.width * EGOPV_ZOOM_SCALE > (2 * borderX + self.frame.size.width))) {
        if (rectToZoom.origin.x < borderX/EGOPV_ZOOM_SCALE) {
            rectToZoom.origin.x = borderX/EGOPV_ZOOM_SCALE;
        } else if (CGRectGetMaxX(rectToZoom) > self.frame.size.width - borderX/EGOPV_ZOOM_SCALE) {
            rectToZoom.origin.x = self.frame.size.width - borderX/EGOPV_ZOOM_SCALE - rectToZoom.size.width;
        }
    }
    if ((borderY > 0.0f) && (self.frame.size.height * EGOPV_ZOOM_SCALE > (2 * borderY + self.frame.size.height))) {
        if (rectToZoom.origin.y < borderY/EGOPV_ZOOM_SCALE) {
            rectToZoom.origin.y = borderY/EGOPV_ZOOM_SCALE;
        } else if (CGRectGetMaxY(rectToZoom) > self.frame.size.height - borderY/EGOPV_ZOOM_SCALE) {
            rectToZoom.origin.y = self.frame.size.height - borderY/EGOPV_ZOOM_SCALE - rectToZoom.size.height;
        }
    }
    
    //Case 2.2:图片放大指定倍数后，宽高无法覆盖整个屏幕(即小于EGOPhotoImageView的宽高)，需要偏移一定量，以保证动画平滑过渡到最终放大效果
    if ((borderX > 0.0f) && (self.frame.size.width * EGOPV_ZOOM_SCALE <= (2 * borderX + self.frame.size.width))) {
        CGFloat horizontalGapToMinus = (self.frame.size.width * EGOPV_ZOOM_SCALE - self.frame.size.width) / (2 * EGOPV_ZOOM_SCALE);
        if (rectToZoom.origin.x < horizontalGapToMinus) {
            rectToZoom.origin.x = horizontalGapToMinus;
        } else if (CGRectGetMaxX(rectToZoom) > (self.frame.size.width - horizontalGapToMinus)) {
            rectToZoom.origin.x = self.frame.size.width - horizontalGapToMinus - rectToZoom.size.width;
        }
    }
    if ((borderY > 0.0f) && (self.frame.size.height * EGOPV_ZOOM_SCALE <= (2 * borderY + self.frame.size.height))) {
        CGFloat verticalGapToMinus = (self.frame.size.height * EGOPV_ZOOM_SCALE - self.frame.size.height) / (2 * EGOPV_ZOOM_SCALE);
        if (rectToZoom.origin.y < verticalGapToMinus) {
            rectToZoom.origin.y = verticalGapToMinus;
        } else if (CGRectGetMaxY(rectToZoom) > (self.frame.size.height - verticalGapToMinus)) {
            rectToZoom.origin.y = self.frame.size.height - verticalGapToMinus - rectToZoom.size.height;
        }
    }

	[self zoomToRect:rectToZoom animated:YES];
}

- (void)singleTapAction{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EGOPhotoViewSingleTapped" object:nil];
}


#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
	UITouch *touch = [touches anyObject];
	
	if (touch.tapCount == 1) {
		[self performSelector:@selector(singleTapAction) withObject:nil afterDelay:.4];
	} else if (touch.tapCount == 2) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object:nil];
		[self zoomRectWithCenter:[[touches anyObject] locationInView:self]];
	}
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [super dealloc];
}


@end
