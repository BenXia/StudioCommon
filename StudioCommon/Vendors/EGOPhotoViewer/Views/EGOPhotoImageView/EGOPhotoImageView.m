//
//  EGOPhotoImageView.m
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

#import "EGOPhotoImageView.h"
#import "UIImageView+WebCache.h"

#define ZOOM_VIEW_TAG 0x101

@interface RotateGesture : UIRotationGestureRecognizer {}
@end

@implementation RotateGesture
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer*)gesture{
	return NO;
}
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer{
	return YES;
}
@end


@interface EGOPhotoImageView (Private)
- (void)layoutScrollViewAnimated:(BOOL)animated;
- (void)handleFailedImage;
- (void)setupImageViewWithImage:(UIImage *)aImage;
- (CABasicAnimation*)fadeAnimation;
@end


@implementation EGOPhotoImageView 

@synthesize photo=_photo;
@synthesize imageView=_imageView;
@synthesize scrollView=_scrollView;
@synthesize loading=_loading;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor clearColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.opaque = YES;
		
		EGOPhotoScrollView *scrollView = [[EGOPhotoScrollView alloc] initWithFrame:self.bounds];
		scrollView.backgroundColor = [UIColor blackColor];
		scrollView.opaque = YES;
		scrollView.delegate = self;
		[self addSubview:scrollView];
		_scrollView = [scrollView retain];
		[scrollView release];

		UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		imageView.opaque = YES;
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.tag = ZOOM_VIEW_TAG;
		[_scrollView addSubview:imageView];
		_imageView = [imageView retain];
		[imageView release];
        
        QQingProgressView *progressView = [[QQingProgressView alloc] init];
        progressView.frame = CGRectMake(((CGRectGetWidth(self.frame) - progressView.frame.size.width) / 2),
                                        (CGRectGetHeight(self.frame) - progressView.frame.size.width) / 2,
                                        progressView.frame.size.width,
                                        progressView.frame.size.height);
		progressView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
		[self addSubview:progressView];
        _progressView.hidden = YES;
		_progressView = [progressView retain];
		[progressView release];
		
//		RotateGesture *gesture = [[RotateGesture alloc] initWithTarget:self action:@selector(rotate:)];
//		[self addGestureRecognizer:gesture];
//		[gesture release];
        
        UIView *topClearView = [[UIView alloc] initWithFrame:self.bounds];
        topClearView.backgroundColor = [UIColor clearColor];
        [self addSubview:topClearView];
        _topClearViewForTapClose = [topClearView retain];
        [topClearView release];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForCloseAction:)];
        [_topClearViewForTapClose addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        _scrollView.userInteractionEnabled = NO;
        _topClearViewForTapClose.hidden = NO;
	}
    return self;
}

- (void)layoutSubviews{
	[super layoutSubviews];
		
	if (_scrollView.zoomScale == 1.0f) {
		[self layoutScrollViewAnimated:YES];
	}
	
}

- (void)setPhoto:(id <EGOPhoto>)aPhoto{
	
	if (!aPhoto) return; 
	if ([aPhoto isEqual:self.photo]) return;
	
	[_photo release], _photo = nil;
	_photo = [aPhoto retain];
	
    void (^startLoadImageOperation)(void) = ^{
        _loading = YES;
        _progressView.hidden = NO;
        _progressView.progress = 0;
        self.scrollView.userInteractionEnabled= NO;
        self.topClearViewForTapClose.hidden = NO;
        if (self.photo.previewImage) {
            self.imageView.image=self.photo.previewImage;
        } else {
            self.imageView.image = kEGOPhotoLoadingPlaceholder;
        }
    };
    
    void (^finishLoadImageOperation)(void) = ^{
        _progressView.progress = 1;
        _progressView.hidden = YES;
        self.scrollView.userInteractionEnabled = YES;
        self.topClearViewForTapClose.hidden = YES;
        
        _loading=NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EGOPhotoDidFinishLoading" object:[NSDictionary dictionaryWithObjectsAndKeys:self.photo, @"photo", [NSNumber numberWithBool:NO], @"failed", nil]];
    };
    
	if (self.photo.image) {
		self.imageView.image = self.photo.image;
	} else {
		if ([self.photo.URL isFileURL]) {
			NSError *error = nil;
			NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self.photo.URL path] error:&error];
			NSInteger fileSize = [[attributes objectForKey:NSFileSize] integerValue];

			if (fileSize >= 1048576 && [[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
								
				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
					
					UIImage *_image = nil;
					NSData *_data = [NSData dataWithContentsOfURL:self.photo.URL];
					if (!_data) {
						[self handleFailedImage];
					} else {
						_image = [UIImage imageWithData:_data];
					}
					
					dispatch_async(dispatch_get_main_queue(), ^{
						
						if (_image!=nil) {
							[self setupImageViewWithImage:_image];
						}
					});
				});
			} else {
				self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photo.URL]];
			}
		} else {
            __unsafe_unretained EGOPhotoImageView *unretainSelf = self;
            __unsafe_unretained id<EGOPhoto> unretainPhoto = self.photo;
            __unsafe_unretained QQingProgressView *unretainProgressView = _progressView;
            
            startLoadImageOperation();
            
            [_imageView sd_setImageWithURL:self.photo.URL
                          placeholderImage:self.photo.previewImage ? self.photo.previewImage : kEGOPhotoLoadingPlaceholder
                                   options:SDWebImageRetryFailed|SDWebImageLowPriority
                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                      if (expectedSize > 0) {
                                          [unretainProgressView setProgress:((CGFloat)receivedSize) / expectedSize animated:YES];
                                      }
                                  }
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (![imageURL isEqual:unretainPhoto.URL]) {
                                         return;
                                     }
                                     
                                     if (image) {
                                         [unretainSelf setupImageViewWithImage:image];
                                     } else {
                                         [unretainSelf handleFailedImage];
                                     }
                                }];
            
            [self layoutScrollViewAnimated:NO];
            
            return;
		}
	}
	
	if (self.imageView.image) {
        finishLoadImageOperation();
	} else {
        startLoadImageOperation();
	}
	
	[self layoutScrollViewAnimated:NO];
}

- (void)setupImageViewWithImage:(UIImage*)aImage {	
	if (!aImage) return; 

	_loading = NO;
    _progressView.progress=1;
    _progressView.hidden = YES;
	self.imageView.image = aImage; 
	[self layoutScrollViewAnimated:NO];
	
	[[self layer] addAnimation:[self fadeAnimation] forKey:@"opacity"];
	self.scrollView.userInteractionEnabled = YES;
    self.topClearViewForTapClose.hidden = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EGOPhotoDidFinishLoading" object:[NSDictionary dictionaryWithObjectsAndKeys:self.photo, @"photo", [NSNumber numberWithBool:NO], @"failed", nil]];
	
}

- (void)prepareForReusue{
	//  reset view
	self.tag = -1;
	self.photo = nil;
}

- (void)handleFailedImage{
    if (self.photo.previewImage) {
        self.imageView.image = self.photo.previewImage;
    } else {
        self.imageView.image = kEGOPhotoErrorPlaceholder;
    }
    
    MBProgressHUD *tmpHUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    tmpHUD.userInteractionEnabled = NO; //显示提示的时候, 可以操作其他部分
    tmpHUD.color = [UIColor darkGrayColor];
    tmpHUD.labelText = @"图片加载失败";
    tmpHUD.mode = MBProgressHUDModeText;
    [tmpHUD hide:YES afterDelay:1];
    
	self.photo.failed = YES;
	[self layoutScrollViewAnimated:NO];
	self.scrollView.userInteractionEnabled = NO;
    self.topClearViewForTapClose.hidden = NO;
    _progressView.hidden = YES;
    _progressView.progress = 0;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EGOPhotoDidFinishLoading" object:[NSDictionary dictionaryWithObjectsAndKeys:self.photo, @"photo", [NSNumber numberWithBool:YES], @"failed", nil]];
	
}

#pragma mark -
#pragma mark Parent Controller Fading

- (void)fadeView{
	
	self.backgroundColor = [UIColor clearColor];
	self.superview.backgroundColor = self.backgroundColor;
	self.superview.superview.backgroundColor = self.backgroundColor;
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
	[animation setValue:[NSNumber numberWithInt:101] forKey:@"AnimationType"];
	animation.delegate = self;
	animation.fromValue = (id)[UIColor clearColor].CGColor;
	animation.toValue = (id)[UIColor blackColor].CGColor;
	animation.duration = 0.4f;
	[self.layer addAnimation:animation forKey:@"FadeAnimation"];
	
	
}

- (void)resetBackgroundColors{
	
	self.backgroundColor = [UIColor blackColor];
	self.superview.backgroundColor = self.backgroundColor;
	self.superview.superview.backgroundColor = self.backgroundColor;

}


#pragma mark -
#pragma mark Layout

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation{

	if (self.scrollView.zoomScale > 1.0f) {
		
		CGFloat height, width;
		height = MIN(CGRectGetHeight(self.imageView.frame) + self.imageView.frame.origin.x, CGRectGetHeight(self.bounds));
		width = MIN(CGRectGetWidth(self.imageView.frame) + self.imageView.frame.origin.y, CGRectGetWidth(self.bounds));
		self.scrollView.frame = CGRectMake((self.bounds.size.width / 2) - (width / 2), (self.bounds.size.height / 2) - (height / 2), width, height);
		
	} else {
		
		[self layoutScrollViewAnimated:NO];
		
	}
}

- (void)layoutScrollViewAnimated:(BOOL)animated{

	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.0001];
	}

	CGFloat hfactor = self.imageView.image.size.width / self.frame.size.width;
	CGFloat vfactor = self.imageView.image.size.height / self.frame.size.height;
	
	CGFloat factor = MAX(hfactor, vfactor);
    if (factor <= 1e-6) {
        factor = 1;
    }
	
	CGFloat newWidth = self.imageView.image.size.width / factor;
	CGFloat newHeight = self.imageView.image.size.height / factor;
	
	CGFloat leftOffset = (self.frame.size.width - newWidth) / 2;
	CGFloat topOffset = (self.frame.size.height - newHeight) / 2;
	
	self.scrollView.frame = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
	self.scrollView.layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
	self.scrollView.contentOffset = CGPointMake(0.0f, 0.0f);
	self.imageView.frame = self.scrollView.bounds;


	if (animated) {
		[UIView commitAnimations];
	}
}

- (CGSize)sizeForPopover{
	
	CGSize popoverSize = EGOPV_MAX_POPOVER_SIZE;
	
	if (!self.imageView.image) {
		return popoverSize;
	}
	
	CGSize imageSize = self.imageView.image.size;
	
	if(imageSize.width > popoverSize.width || imageSize.height > popoverSize.height) {
		
		if(imageSize.width > imageSize.height) {
			popoverSize.height = floorf((popoverSize.width * imageSize.height) / imageSize.width);
		} else {
			popoverSize.width = floorf((popoverSize.height * imageSize.width) / imageSize.height);
		}
		
	} else {
		
		popoverSize = imageSize;
		
	}
	
	if (popoverSize.width < EGOPV_MIN_POPOVER_SIZE.width || popoverSize.height < EGOPV_MIN_POPOVER_SIZE.height) {
		
		CGFloat hfactor = popoverSize.width / EGOPV_MIN_POPOVER_SIZE.width;
		CGFloat vfactor = popoverSize.height / EGOPV_MIN_POPOVER_SIZE.height;
		
		CGFloat factor = MAX(hfactor, vfactor);
		
		CGFloat newWidth = popoverSize.width / factor;
		CGFloat newHeight = popoverSize.height / factor;
		
		popoverSize.width = newWidth;
		popoverSize.height = newHeight;
		
	} 
	
	
	return popoverSize;
	
}


#pragma mark -
#pragma mark Animation

- (CABasicAnimation*)fadeAnimation{
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	animation.fromValue = [NSNumber numberWithFloat:0.0f];
	animation.toValue = [NSNumber numberWithFloat:1.0f];
	animation.duration = .3f;
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	
	return animation;
}


#pragma mark -
#pragma mark UIScrollView Delegate Methods

- (void)killZoomAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	
	if([finished boolValue]){
		
		[self.scrollView setZoomScale:1.0f animated:NO];
		self.imageView.frame = self.scrollView.bounds;
		[self layoutScrollViewAnimated:NO];
		
	}
	
}

- (void)killScrollViewZoom{
	
	if (!self.scrollView.zoomScale > 1.0f) return;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDidStopSelector:@selector(killZoomAnimationDidStop:finished:context:)];
	[UIView setAnimationDelegate:self];

	CGFloat hfactor = self.imageView.image.size.width / self.frame.size.width;
	CGFloat vfactor = self.imageView.image.size.height / self.frame.size.height;
	
	CGFloat factor = MAX(hfactor, vfactor);
		
	CGFloat newWidth = self.imageView.image.size.width / factor;
	CGFloat newHeight = self.imageView.image.size.height / factor;
		
	CGFloat leftOffset = (self.frame.size.width - newWidth) / 2;
	CGFloat topOffset = (self.frame.size.height - newHeight) / 2;

    if (isnan(leftOffset)) {
        leftOffset = 0;
    }
    if (isnan(topOffset)) {
        topOffset = 0;
    }
    if (isnan(newWidth)) {
        newWidth = 0;
    }
    if (isnan(newHeight)) {
        newHeight = 0;
    }
    
	self.scrollView.frame = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
	self.imageView.frame = self.scrollView.bounds;
	[UIView commitAnimations];

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return [self.scrollView viewWithTag:ZOOM_VIEW_TAG];
}

- (CGRect)frameToFitCurrentView{
	
	CGFloat heightFactor = self.imageView.image.size.height / self.frame.size.height;
	CGFloat widthFactor = self.imageView.image.size.width / self.frame.size.width;
	
	CGFloat scaleFactor = MAX(heightFactor, widthFactor);
	
	CGFloat newHeight = self.imageView.image.size.height / scaleFactor;
	CGFloat newWidth = self.imageView.image.size.width / scaleFactor;
	
	
	CGRect rect = CGRectMake((self.frame.size.width - newWidth)/2, (self.frame.size.height-newHeight)/2, newWidth, newHeight);
	
	return rect;
	
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
	if (scrollView.zoomScale > 1.0f) {
		
		CGFloat height, width, originX, originY;
        
        QQLog (@"self.imageView.frame: %@", NSStringFromCGRect(self.imageView.frame));
        QQLog (@"self.bounds: %@", NSStringFromCGRect(self.bounds));
        
		height = MIN(CGRectGetHeight(self.imageView.frame) + self.imageView.frame.origin.x, CGRectGetHeight(self.bounds));
		width = MIN(CGRectGetWidth(self.imageView.frame) + self.imageView.frame.origin.y, CGRectGetWidth(self.bounds));
		
		if (CGRectGetMaxX(self.imageView.frame) > self.bounds.size.width) {
			width = CGRectGetWidth(self.bounds);
			originX = 0.0f;
		} else {
			width = CGRectGetMaxX(self.imageView.frame);
			
			if (self.imageView.frame.origin.x < 0.0f) {
				originX = 0.0f;
			} else {
				originX = self.imageView.frame.origin.x;
			}
		}
		
		if (CGRectGetMaxY(self.imageView.frame) > self.bounds.size.height) {
			height = CGRectGetHeight(self.bounds);
			originY = 0.0f;
		} else {
			height = CGRectGetMaxY(self.imageView.frame);
			
			if (self.imageView.frame.origin.y < 0.0f) {
				originY = 0.0f;
			} else {
				originY = self.imageView.frame.origin.y;
			}
		}
        
		CGRect frame = self.scrollView.frame;
        
        QQLog (@"self.scrollView.beforeContentOffset: %@", NSStringFromCGPoint(self.scrollView.contentOffset));
        
        BOOL isRightSideContent = NO;
        BOOL isBottomSideContent = NO;
        
        if (((self.imageView.frame.size.height  - self.scrollView.contentOffset.y) >= (frame.origin.y + frame.size.height - 2)) &&
            ((self.imageView.frame.size.height - self.scrollView.contentOffset.y) <= (frame.origin.y + frame.size.height + 2))) {
            isBottomSideContent = YES;
        }
        
        if (((self.imageView.frame.size.width  - self.scrollView.contentOffset.x) >= (frame.origin.x + frame.size.width - 2)) &&
            ((self.imageView.frame.size.width - self.scrollView.contentOffset.x) <= (frame.origin.x + frame.size.width + 2))) {
            isRightSideContent = YES;
        }
        
		self.scrollView.frame = CGRectMake((self.bounds.size.width / 2) - (width / 2), (self.bounds.size.height / 2) - (height / 2), width, height);
		self.scrollView.layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        
        QQLog (@"self.scrollView.afterContentOffset: %@", NSStringFromCGPoint(self.scrollView.contentOffset));
        
		if (!CGRectEqualToRect(frame, self.scrollView.frame)) {
			
            CGFloat voffsetY;
            CGFloat voffsetX;
            
            QQLog (@"oldScrollViewFrame: %@  newScrollViewFrame: %@  scrollView.contentOffset: %@", NSStringFromCGRect(frame), NSStringFromCGRect(self.scrollView.frame), NSStringFromCGPoint(self.scrollView.contentOffset));
            
			if (frame.origin.y < self.scrollView.frame.origin.y) {
				voffsetY = self.scrollView.contentOffset.y - (self.scrollView.frame.origin.y - frame.origin.y);
			} else {
				voffsetY = self.scrollView.contentOffset.y - (frame.origin.y - self.scrollView.frame.origin.y);
			}
			
			if (frame.origin.x < self.scrollView.frame.origin.x) {
				voffsetX = self.scrollView.contentOffset.x - (self.scrollView.frame.origin.x - frame.origin.x);
			} else {
				voffsetX = self.scrollView.contentOffset.x - (frame.origin.x - self.scrollView.frame.origin.x);
			}
            
            if (isBottomSideContent) {
                voffsetY = self.imageView.frame.size.height - height;
            } else if (voffsetY < 0) {
                voffsetY = 0;
            }
            
            if (isRightSideContent) {
                voffsetX = self.imageView.frame.size.width - width;
            } else if (voffsetX < 0) {
                voffsetX = 0;
            }
			
			self.scrollView.contentOffset = CGPointMake(voffsetX, voffsetY);
		}
        
	} else {
		[self layoutScrollViewAnimated:NO];
	}
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
	if (scrollView.zoomScale > 1.0f) {		
		
		CGFloat height, width, originX, originY;
        
        QQLog (@"self.imageView.frame: %@", NSStringFromCGRect(self.imageView.frame));
        QQLog (@"self.bounds: %@", NSStringFromCGRect(self.bounds));
        
		height = MIN(CGRectGetHeight(self.imageView.frame) + self.imageView.frame.origin.x, CGRectGetHeight(self.bounds));
		width = MIN(CGRectGetWidth(self.imageView.frame) + self.imageView.frame.origin.y, CGRectGetWidth(self.bounds));
		
		if (CGRectGetMaxX(self.imageView.frame) > self.bounds.size.width) {
			width = CGRectGetWidth(self.bounds);
			originX = 0.0f;
		} else {
			width = CGRectGetMaxX(self.imageView.frame);
			
			if (self.imageView.frame.origin.x < 0.0f) {
				originX = 0.0f;
			} else {
				originX = self.imageView.frame.origin.x;
			}	
		}
		
		if (CGRectGetMaxY(self.imageView.frame) > self.bounds.size.height) {
			height = CGRectGetHeight(self.bounds);
			originY = 0.0f;
		} else {
			height = CGRectGetMaxY(self.imageView.frame);
			
			if (self.imageView.frame.origin.y < 0.0f) {
				originY = 0.0f;
			} else {
				originY = self.imageView.frame.origin.y;
			}
		}

		CGRect frame = self.scrollView.frame;
        
        QQLog (@"self.scrollView.beforeContentOffset: %@", NSStringFromCGPoint(self.scrollView.contentOffset));

        BOOL isRightSideContent = NO;
        BOOL isBottomSideContent = NO;
        
        if (((self.imageView.frame.size.height  - self.scrollView.contentOffset.y) >= (frame.origin.y + frame.size.height - 2)) &&
            ((self.imageView.frame.size.height - self.scrollView.contentOffset.y) <= (frame.origin.y + frame.size.height + 2))) {
            isBottomSideContent = YES;
        }
        
        if (((self.imageView.frame.size.width  - self.scrollView.contentOffset.x) >= (frame.origin.x + frame.size.width - 2)) &&
            ((self.imageView.frame.size.width - self.scrollView.contentOffset.x) <= (frame.origin.x + frame.size.width + 2))) {
            isRightSideContent = YES;
        }
        
		self.scrollView.frame = CGRectMake((self.bounds.size.width / 2) - (width / 2), (self.bounds.size.height / 2) - (height / 2), width, height);
		self.scrollView.layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        
        QQLog (@"self.scrollView.afterContentOffset: %@", NSStringFromCGPoint(self.scrollView.contentOffset));

		if (!CGRectEqualToRect(frame, self.scrollView.frame)) {
			
            CGFloat voffsetY;
            CGFloat voffsetX;

            QQLog (@"oldScrollViewFrame: %@  newScrollViewFrame: %@  scrollView.contentOffset: %@", NSStringFromCGRect(frame), NSStringFromCGRect(self.scrollView.frame), NSStringFromCGPoint(self.scrollView.contentOffset));
        
			if (frame.origin.y < self.scrollView.frame.origin.y) {
				voffsetY = self.scrollView.contentOffset.y - (self.scrollView.frame.origin.y - frame.origin.y);
			} else {				
				voffsetY = self.scrollView.contentOffset.y - (frame.origin.y - self.scrollView.frame.origin.y);
			}
			
			if (frame.origin.x < self.scrollView.frame.origin.x) {
				voffsetX = self.scrollView.contentOffset.x - (self.scrollView.frame.origin.x - frame.origin.x);
			} else {				
				voffsetX = self.scrollView.contentOffset.x - (frame.origin.x - self.scrollView.frame.origin.x);
			}

            if (isBottomSideContent) {
                voffsetY = self.imageView.frame.size.height - height;
            } else if (voffsetY < 0) {
                voffsetY = 0;
            }
            
            if (isRightSideContent) {
                voffsetX = self.imageView.frame.size.width - width;
            } else if (voffsetX < 0) {
                voffsetX = 0;
            }
			
			self.scrollView.contentOffset = CGPointMake(voffsetX, voffsetY);
		}

	} else {
		[self layoutScrollViewAnimated:YES];
	}
}


#pragma mark -
#pragma mark RotateGesture

- (void)rotate:(UIRotationGestureRecognizer*)gesture{

	if (gesture.state == UIGestureRecognizerStateBegan) {
		
		[self.layer removeAllAnimations];
		_beginRadians = gesture.rotation;
		self.layer.transform = CATransform3DMakeRotation(_beginRadians, 0.0f, 0.0f, 1.0f);
		
	} else if (gesture.state == UIGestureRecognizerStateChanged) {
		
		self.layer.transform = CATransform3DMakeRotation((_beginRadians + gesture.rotation), 0.0f, 0.0f, 1.0f);

	} else {
		
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
		animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
		animation.duration = 0.3f;
		animation.removedOnCompletion = NO;
		animation.fillMode = kCAFillModeForwards;
		animation.delegate = self;
		[animation setValue:[NSNumber numberWithInt:202] forKey:@"AnimationType"];
		[self.layer addAnimation:animation forKey:@"RotateAnimation"];
		
	} 

	
}

- (void)tapForCloseAction:(UITapGestureRecognizer *)tapGesture{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EGOPhotoViewSingleTapped" object:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	
	if (flag) {
		
		if ([[anim valueForKey:@"AnimationType"] integerValue] == 101) {
			
			[self resetBackgroundColors];
			
		} else if ([[anim valueForKey:@"AnimationType"] integerValue] == 202) {
			
			self.layer.transform = CATransform3DIdentity;
			
		}
	}
	
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	if (_photo) {
        [_imageView sd_cancelCurrentImageLoad];
	}
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [_progressView release], _progressView=nil;
	[_activityView release], _activityView=nil;
	[_imageView release]; _imageView=nil;
	[_scrollView release]; _scrollView=nil;
    [_topClearViewForTapClose release]; _topClearViewForTapClose = nil;
	[_photo release]; _photo=nil;
    [super dealloc];
	
}


@end
