//
//  QQingPhotosBrowserVC.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "QQingPhotosBrowserVC.h"
#import "QQingPageControl.h"

#define ENABLE_FULLSCREEN 1

static const CGFloat kToolViewHeight = 40;
static const CGFloat kTitleLabelWidth = 100;
static const CGFloat kTitleLabelHeight = 40;
static const CGFloat kPageControlWidth = 100;
static const CGFloat kPageControlHeight = 25;
static const CGFloat kPageControlBottomPadding = 5;
static const CGFloat kButtonWidth = 40;
static const CGFloat kButtonHeight = 40;
static const CGFloat kButtonLeadingTrailingPadding = 5;

static const NSTimeInterval kShowAnimationDuration = 0.3;
static const NSTimeInterval kCloseAnimationDuration = 0.3;

@interface QQingPhotosBrowserVC () <UIScrollViewDelegate>

@property (nonatomic, strong) id<EGOPhotoSource> photoSource;
@property (nonatomic, strong) NSMutableArray *photoViews;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) QQingPageControl *pageControl;

@property (nonatomic, assign) BOOL oldStatusBarHidden;

@end

@implementation QQingPhotosBrowserVC

- (id)initWithPhotoSource:(id<EGOPhotoSource> )aSource {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singleTapImageNotification:) name:@"EGOPhotoViewSingleTapped" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoViewDidFinishLoading:) name:@"EGOPhotoDidFinishLoading" object:nil];
        
		_photoSource = aSource;
		_pageIndex=0;
	}
	
	return self;
}

- (id)initWithPhoto:(id<EGOPhoto> )aPhoto {
	return [self initWithPhotoSource:[[EGOQuickPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:aPhoto, nil]]];
}

- (id)initWithImage:(UIImage *)anImage {
	return [self initWithPhoto:[[EGOQuickPhoto alloc] initWithImage:anImage]];
}

- (id)initWithImageURL:(NSURL *)anImageURL {
	return [self initWithPhoto:[[EGOQuickPhoto alloc] initWithImageURL:anImageURL]];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
    
    [self setupScrollView];
    [self setupPageControl];
    [self setupToolView];
    
    self.toolView.hidden = self.isOnlyShowImage;
    self.pageControl.hidden = self.isOnlyShowImage;
    
    // 懒加载
	NSMutableArray *views = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < [self.photoSource numberOfPhotos]; i++) {
		[views addObject:[NSNull null]];
	}
	self.photoViews = views;
    
	[self moveToPhotoAtIndex:_pageIndex animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIColor*)preferNavBarBackgroundColor{
    return [UIColor themeBlueColor];
}

- (UIColor*)preferNavBarNormalTitleColor{
    return [UIColor whiteColor];
}

- (UIColor*)preferNavBarHighlightedTitleColor {
    return [UIColor colorWithRed:150 green:150 blue:150 alpha:1];
}

#pragma mark - Public Methods

- (void)showWithImageView:(QQingImageView *)imageView withCompletion:(Block)completeBlock {
    if (!imageView.imageView.image) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.view.tag = kTagOfQQingPhotosBrowserVCView;
        [window addSubview:self.view];
        [window.rootViewController addChildViewController:self];

        // 隐藏状态栏
        _oldStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        if (self.delegate && [self.delegate respondsToSelector:@selector(setStatusBarHidden:)]) {
            [self.delegate setStatusBarHidden:YES];
        }
        
        completeBlock();
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.view.hidden = YES;
    self.view.tag = kTagOfQQingPhotosBrowserVCView;
    [window addSubview:self.view];
    [[Utilities topVisibleChildViewController] addChildViewController:self];
    
    // 打开过渡动画
    BOOL shouldShowOpenAnimation = YES;
    if ([self.delegate respondsToSelector:@selector(shouldShowOpenAnimation)]) {
        shouldShowOpenAnimation = [self.delegate shouldShowOpenAnimation];
    }
    
    if (!shouldShowOpenAnimation) {
        self.view.hidden = NO;
        
        // 隐藏状态栏
        _oldStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        if (self.delegate && [self.delegate respondsToSelector:@selector(setStatusBarHidden:)]) {
            [self.delegate setStatusBarHidden:YES];
        }
        
        completeBlock();
        return;
    }
    
    CGRect tmpViewFrame = [imageView convertRect:imageView.bounds toView:nil];
    UIView *tmpView = [[UIView alloc] initWithFrame:tmpViewFrame];
    tmpView.backgroundColor = [UIColor blackColor];
    tmpView.clipsToBounds = YES;
    
    CGRect tmpImageViewFrame = tmpViewFrame;
    CGFloat widthToHeightRatio = imageView.imageView.image.size.width / imageView.imageView.image.size.height;
    if (widthToHeightRatio > 1) {
        CGFloat startWidth = tmpViewFrame.size.width;
        CGFloat finalWidth = widthToHeightRatio * tmpViewFrame.size.height;
        tmpImageViewFrame.origin.x = -((finalWidth - startWidth) / 2);
        tmpImageViewFrame.origin.y = 0;
        tmpImageViewFrame.size.width = finalWidth;
    } else {
        CGFloat startHeight = tmpViewFrame.size.height;
        CGFloat finalHeight = tmpViewFrame.size.width / widthToHeightRatio;
        tmpImageViewFrame.origin.y = -((finalHeight - startHeight) / 2);
        tmpImageViewFrame.origin.x = 0;
        tmpImageViewFrame.size.height = finalHeight;
    }
    
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:tmpImageViewFrame];
    tmpImageView.backgroundColor = [UIColor clearColor];
    tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
    tmpImageView.image = imageView.imageView.image;
    [tmpView addSubview:tmpImageView];
    [window addSubview:tmpView];
    
    [UIView animateWithDuration:kShowAnimationDuration
                     animations:^{
                         tmpView.frame = CGRectMake(0,
                                                    0,
                                                    kScreenWidth,
                                                    kScreenHeight);
                         if (ENABLE_FULLSCREEN) {
                             tmpImageView.frame = CGRectMake(0,
                                                             0,
                                                             kScreenWidth,
                                                             kScreenHeight);
                         } else {
                             tmpImageView.frame = CGRectMake(0,
                                                             kToolViewHeight,
                                                             kScreenWidth,
                                                             kScreenHeight - kToolViewHeight);
                         }
                     } completion:^(BOOL finished) {
                         self.view.hidden = NO;
                         [tmpView removeFromSuperview];
                         
                         // 隐藏状态栏
                         _oldStatusBarHidden = [UIApplication sharedApplication].statusBarHidden;
                         if (self.delegate && [self.delegate respondsToSelector:@selector(setStatusBarHidden:)]) {
                             [self.delegate setStatusBarHidden:YES];
                         }
                         
                         completeBlock();
                     }];
}

#pragma mark - Private Methods

- (void)setupScrollView {
    CGRect scrollViewFrame = CGRectMake(0, kToolViewHeight, kScreenWidth, kScreenHeight - kToolViewHeight);
    
    if (ENABLE_FULLSCREEN) {
        scrollViewFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
		_scrollView.delegate=self;
		_scrollView.multipleTouchEnabled=YES;
		_scrollView.scrollEnabled=YES;
		_scrollView.directionalLockEnabled=YES;
		_scrollView.canCancelContentTouches=YES;
		_scrollView.delaysContentTouches=YES;
		_scrollView.clipsToBounds=YES;
		_scrollView.alwaysBounceHorizontal=YES;
		_scrollView.bounces=YES;
		_scrollView.pagingEnabled=YES;
		_scrollView.showsVerticalScrollIndicator=NO;
		_scrollView.showsHorizontalScrollIndicator=NO;
		_scrollView.backgroundColor = self.view.backgroundColor;
		[self.view addSubview:_scrollView];
	}
    
    CGSize contentSize = self.view.bounds.size;
	contentSize.width = (contentSize.width * [self.photoSource numberOfPhotos]);
    _scrollView.contentSize = contentSize;
}

- (void)setupPageControl {
    if (!_pageControl) {
        _pageControl = [[QQingPageControl alloc] initWithFrame:CGRectZero withPageCount:[self.photoSource numberOfPhotos]];
        
        _pageControl.frame = CGRectMake((kScreenWidth - kPageControlWidth) / 2,
                                        kScreenHeight - kPageControlHeight - kPageControlBottomPadding,
                                        kPageControlWidth,
                                        kPageControlHeight);
        CGFloat screenScale = [UIScreen mainScreen].scale;
        _pageControl.image = [UIImage circleImageWithColor:[UIColor grayColor] andSize:CGSizeMake(8 * screenScale, 8 * screenScale)];
        _pageControl.highlightedImage = [UIImage circleImageWithColor:[UIColor themeBlueColor] andSize:CGSizeMake(8 * screenScale, 8 * screenScale)];
        _pageControl.point_img_width = 8.0;
        _pageControl.point_max_space = 4.0;
        _pageControl.point_min_space = 2.0;
        _pageControl.showType = show_center;
        
        [_pageControl refreshPageControl];
        
        [self.view addSubview:_pageControl];
        self.pageControl = _pageControl;
        
        self.pageControl.m_curPage = 0;
    }
}

- (void)setupToolView {
    if (!_toolView) {
        CGRect toolViewFrameToSet = CGRectMake(0, 0, kScreenWidth, kToolViewHeight);

        _toolView = [[UIView alloc] initWithFrame:toolViewFrameToSet];
        _toolView.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - kTitleLabelWidth) / 2, kToolViewHeight - kTitleLabelHeight, kTitleLabelWidth, kTitleLabelHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_toolView addSubview:_titleLabel];
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(kButtonLeadingTrailingPadding,
                                                                 kToolViewHeight - kButtonHeight,
                                                                 kButtonWidth,
                                                                 kButtonHeight)];
        [_backButton setImage:[UIImage imageNamed:@"common_topnav_icon01"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_toolView addSubview:_backButton];
        
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - kButtonWidth - kButtonLeadingTrailingPadding,
                                                                   kToolViewHeight - kButtonHeight,
                                                                   kButtonWidth,
                                                                   kButtonHeight)];
        [_actionButton setImage:[UIImage imageNamed:_isEditMode ? @"topnav_icon08" : @"common_topnav_icon02"] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:_isEditMode ? @selector(deleteAction:) : @selector(savePhotoToLocalAction:) forControlEvents:UIControlEventTouchUpInside];
        _actionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_toolView addSubview:_actionButton];
        
        [self.view addSubview:_toolView];
    }
}

- (void)refreshTitleLabel {
    self.titleLabel.text = [NSString stringWithFormat:@"%zd / %zd", _pageIndex + 1, [self.photoSource numberOfPhotos]];
}

- (void)refreshQQingPageControlIndex {
    self.pageControl.m_curPage = _pageIndex;
}

- (void)singleTapImageNotification:(NSNotification*)notification {
	[self closeAction:nil];
}

#pragma mark - Photo View Methods

- (void)photoViewDidFinishLoading:(NSNotification*)notification {
	if (notification == nil) return;
	
	if ([[[notification object] objectForKey:@"photo"] isEqual:[self.photoSource photoAtIndex:[self centerPhotoIndex]]]) {
		[self refreshViewsState];
	}
}

- (NSInteger)centerPhotoIndex {
	CGFloat pageWidth = self.scrollView.frame.size.width;
	return floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)refreshViewsState {
    [self refreshTitleLabel];
    [self refreshQQingPageControlIndex];
}

- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated {
	NSAssert(index < [self.photoSource numberOfPhotos] && index >= 0, @"Photo index passed out of bounds");
	
	_pageIndex = index;
    
	[self enqueuePhotoViewAtIndex:index];
	
	[self loadScrollViewWithPage:index-1];
	[self loadScrollViewWithPage:index];
	[self loadScrollViewWithPage:index+1];
	
	
	[self.scrollView scrollRectToVisible:((EGOPhotoImageView*)[self.photoViews objectAtIndex:index]).frame animated:animated];
	
	//  取消两边的放缩状态
	if (index + 1 < [self.photoSource numberOfPhotos] && (NSNull*)[self.photoViews objectAtIndex:index+1] != [NSNull null]) {
		[((EGOPhotoImageView*)[self.photoViews objectAtIndex:index+1]) killScrollViewZoom];
	}
	if (index - 1 >= 0 && (NSNull*)[self.photoViews objectAtIndex:index-1] != [NSNull null]) {
		[((EGOPhotoImageView*)[self.photoViews objectAtIndex:index-1]) killScrollViewZoom];
	}
    
    [self refreshViewsState];
}

- (void)layoutScrollViewSubviews {
	NSInteger _index = _pageIndex;
	
	for (NSInteger page = _index -1; page < _index+3; page++) {
		
		if (page >= 0 && page < [self.photoSource numberOfPhotos]){
			
			CGFloat originX = self.scrollView.bounds.size.width * page;
			
			if (page < _index) {
				originX -= EGOPV_IMAGE_GAP;
			}
			if (page > _index) {
				originX += EGOPV_IMAGE_GAP;
			}
			
			if ([self.photoViews objectAtIndex:page] == [NSNull null] || !((UIView*)[self.photoViews objectAtIndex:page]).superview){
				[self loadScrollViewWithPage:page];
			}
			
			EGOPhotoImageView *_photoView = (EGOPhotoImageView*)[self.photoViews objectAtIndex:page];
			CGRect newframe = CGRectMake(originX, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
			
			if (!CGRectEqualToRect(_photoView.frame, newframe)) {
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.1];
				_photoView.frame = newframe;
				[UIView commitAnimations];
                
			}
		}
	}
}

- (void)enqueuePhotoViewAtIndex:(NSInteger)theIndex {
	NSInteger count = 0;
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			if (count > theIndex+1 || count < theIndex-1) {
				[view prepareForReusue];
				[view removeFromSuperview];
			} else {
				view.tag = 0;
			}
			
		}
		count++;
	}
}

- (EGOPhotoImageView*)dequeuePhotoView {
	NSInteger count = 0;
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			if (view.superview == nil) {
				view.tag = count;
				return view;
			}
		}
		count ++;
	}
	return nil;
}

- (void)loadScrollViewWithPage:(NSInteger)page {
    if (page < 0) return;
    if (page >= [self.photoSource numberOfPhotos]) return;
	
	EGOPhotoImageView * photoView = [self.photoViews objectAtIndex:page];
	if ((NSNull*)photoView == [NSNull null]) {
		photoView = [self dequeuePhotoView];
		if (photoView != nil) {
			[self.photoViews exchangeObjectAtIndex:photoView.tag withObjectAtIndex:page];
			photoView = [self.photoViews objectAtIndex:page];
		}
	}
	
	if (photoView == nil || (NSNull*)photoView == [NSNull null]) {
		photoView = [[EGOPhotoImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
		[self.photoViews replaceObjectAtIndex:page withObject:photoView];
	}
	
	[photoView setPhoto:[self.photoSource photoAtIndex:page]];
	
    if (photoView.superview == nil) {
		[self.scrollView addSubview:photoView];
	}
	
	CGRect frame = self.scrollView.frame;
	NSInteger centerPageIndex = _pageIndex;
	CGFloat xOrigin = (frame.size.width * page);
	if (page > centerPageIndex) {
		xOrigin = (frame.size.width * page) + EGOPV_IMAGE_GAP;
	} else if (page < centerPageIndex) {
		xOrigin = (frame.size.width * page) - EGOPV_IMAGE_GAP;
	}
	
	frame.origin.x = xOrigin;
	frame.origin.y = 0;
	photoView.frame = frame;
}

- (EGOPhotoImageView *)photoImageViewForIndex:(NSInteger)index {
    for (EGOPhotoImageView *photoView in self.scrollView.subviews) {
        if (photoView.photo == [self.photoSource photoAtIndex:index]) {
            return photoView;
        }
    }
    return nil;
}

#pragma mark - IBActions

- (IBAction)closeAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(willCloseVCWithPhotoSource:)]) {
        [self.delegate willCloseVCWithPhotoSource:self.photoSource];
    }
    
    EGOPhotoImageView *currentPhotoSubView = [self photoImageViewForIndex:_pageIndex];
    UIImage *screenShoot = currentPhotoSubView.imageView.image;
    id<QQingPhotosBrowserVCDelegate> selfDelegate = self.delegate;
    CGRect startViewFrame = [currentPhotoSubView.imageView convertRect:currentPhotoSubView.imageView.bounds toView:nil];
    
    NSInteger remainImagesCount = [self.photoSource numberOfPhotos];
    
    self.toolView.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    // 关闭过渡动画
    BOOL shouldShowCloseAnimation = NO;
    UIView *imageSuperView = nil;
    NSInteger imageTagOffset = -1;
    
    if ([selfDelegate respondsToSelector:@selector(shouldShowCloseAnimation)]) {
        shouldShowCloseAnimation = [selfDelegate shouldShowCloseAnimation];
    }
    if ([selfDelegate respondsToSelector:@selector(imageViewContentViewForCloseAnimation)]) {
        imageSuperView = [selfDelegate imageViewContentViewForCloseAnimation];
    }
    if ([selfDelegate respondsToSelector:@selector(imageViewTagOffsetForCloseAnimation)]) {
        imageTagOffset = [selfDelegate imageViewTagOffsetForCloseAnimation];
    }
    
    // 恢复状态栏原始状态
    if (selfDelegate && [selfDelegate respondsToSelector:@selector(setStatusBarHidden:)]) {
        [selfDelegate setStatusBarHidden:_oldStatusBarHidden];
    }
    
    if ((remainImagesCount == 0) || !shouldShowCloseAnimation || !imageSuperView || (imageTagOffset < 0)) {
        return;
    }

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *tmpView = [[UIView alloc] initWithFrame:startViewFrame];
    tmpView.backgroundColor = [UIColor blackColor];
    tmpView.clipsToBounds = YES;
    
    CGRect startImageViewFrame = startViewFrame;
    startImageViewFrame.origin = CGPointMake(0, 0);
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:startImageViewFrame];
    tmpImageView.backgroundColor = [UIColor clearColor];
    tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
    tmpImageView.image = screenShoot;
    tmpImageView.userInteractionEnabled = YES;
    [tmpView addSubview:tmpImageView];
    [window addSubview:tmpView];

    QQingImageView *currentSubImageView = ((QQingImageView *)[imageSuperView viewWithTag:_pageIndex + imageTagOffset]);
    currentSubImageView.hidden = YES;

    CGRect finalViewFrame = [currentSubImageView convertRect:currentSubImageView.bounds toView:nil];
    
    CGRect finalImageViewFrame = finalViewFrame;
    CGFloat widthToHeightRatio = screenShoot.size.width / screenShoot.size.height;
    if (widthToHeightRatio > 1) {
        CGFloat startWidth = finalViewFrame.size.width;
        CGFloat finalWidth = widthToHeightRatio * finalViewFrame.size.height;
        finalImageViewFrame.origin.x = -((finalWidth - startWidth) / 2);
        finalImageViewFrame.origin.y = 0;
        finalImageViewFrame.size.width = finalWidth;
    } else {
        CGFloat startHeight = finalViewFrame.size.height;
        CGFloat finalHeight = finalViewFrame.size.width / widthToHeightRatio;
        finalImageViewFrame.origin.y = -((finalHeight - startHeight) / 2);
        finalImageViewFrame.origin.x = 0;
        finalImageViewFrame.size.height = finalHeight;
    }
    
    tmpView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:kCloseAnimationDuration
                  animations:^{
                      tmpView.frame = finalViewFrame;
                      tmpImageView.frame = finalImageViewFrame;
                } completion:^(BOOL finished) {
                      currentSubImageView.hidden = NO;
                      [tmpView removeFromSuperview];
    }];
}

- (IBAction)savePhotoToLocalAction:(id)sender {
    if (![Utilities checkPhotoLibraryAccess]) {
        [Utilities showAlertView:@""
                                :@"请在iPhone的“设置－隐私－照片”选项中，允许App访问您的手机相册。"
                                :@"知道了"];
    } else {
        UIImageWriteToSavedPhotosAlbum(((EGOPhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image,
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error != NULL) {
        [Utilities showToastWithText:@"图片保存失败"];
    } else {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_completed_icon"]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"图片已保存";
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
    }
}

- (IBAction)deleteAction:(id)sender {
    QQingAlertView *alertView = [[QQingAlertView alloc]
                                 initWithTitle:nil
                                 message:@"确定要删除?"
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles:@"确定",nil];
    [alertView showWithDismissBlock:^(QQingAlertView *alertView, int dismissButtonIndex) {
        if (dismissButtonIndex == 1) {
            [self deleteImage];
        }
    }];
}

-(void)deleteImage{
    static BOOL s_inDeleteAnimating = NO;    //避免多次点击，动画效果不正确
    if (s_inDeleteAnimating) {
        return;
    }
    
    s_inDeleteAnimating = YES;
    
    UIView *currentPhotoSubView = [self photoImageViewForIndex:_pageIndex];
    NSMutableArray *afterSubScrollViews = [NSMutableArray array];
    
    CGFloat kContentScrollViewWidth = _scrollView.frame.size.width;
    CGFloat kContentScrollViewHeight = _scrollView.frame.size.height;
    
    for (NSUInteger i = _pageIndex + 1; i < [self.photoSource numberOfPhotos]; i++) {
        UIView *subView = [self photoImageViewForIndex:i];
        if (subView) {
            [afterSubScrollViews addObject:subView];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        currentPhotoSubView.y = kContentScrollViewHeight;
    } completion:^(BOOL finished) {
        [currentPhotoSubView removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            for (UIView *subview in afterSubScrollViews) {
                subview.x = subview.x - kContentScrollViewWidth - EGOPV_IMAGE_GAP;
            }
        } completion:^(BOOL finished) {
            [self.photoViews removeObjectAtIndex:_pageIndex];
            [self.photoSource removePhotoAtIndex:_pageIndex];
            [self loadScrollViewWithPage:_pageIndex + 1];
            _scrollView.contentSize = CGSizeMake(kContentScrollViewWidth * self.photoViews.count, kContentScrollViewHeight);
            if ([self.photoSource numberOfPhotos] == 0) {
                [self closeAction:nil];
                s_inDeleteAnimating = NO;
            } else {
                [self.pageControl setPageCount:[self.photoSource numberOfPhotos]];
                [self refreshViewsState];
                s_inDeleteAnimating = NO;
            }
        }];
    }];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSInteger _index = [self centerPhotoIndex];
	if (_index >= [self.photoSource numberOfPhotos] || _index < 0) {
		return;
	}
	
	if (_pageIndex != _index) {
		_pageIndex = _index;
		[self refreshViewsState];
		
		if (![scrollView isTracking]) {
			[self layoutScrollViewSubviews];
		}
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSInteger _index = [self centerPhotoIndex];
	if (_index >= [self.photoSource numberOfPhotos] || _index < 0) {
		return;
	}
	
	[self moveToPhotoAtIndex:_index animated:YES];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
	[self layoutScrollViewSubviews];
}

@end
