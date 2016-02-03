//
//  QQingImageView.m
//  StudioCommon
//
//  Created by Ben on 8/6/15.
//  Copyright © 2016年 StudioCommon. All rights reserved.

// 统一使用SDImageCache

#import "QQingImageView.h"
#import "UIImageView+WebCache.h"

@interface QQingImageView ()

@property (nonatomic, assign) BOOL isMove;

@property (nonatomic, strong) QQingProgressView *progressView;
@property (nonatomic, strong) UIView *loadingFailContentView;

@end

@implementation QQingImageView

#pragma mark - Initialize

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInitWithSize:self.frame.size];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInitWithSize:self.frame.size];
    }
    
    return self;
}

- (id)initWithURL:(NSURL *)url defaultImageName:(NSString *)defaultImageName imageSize:(CGSize)size {
    UIImage *defaultImage = [UIImage imageNamed:defaultImageName];
    CGSize sizeToSet = size;
    
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        sizeToSet = CGSizeMake(defaultImage.size.width, defaultImage.size.height);
    }
    
    if (self = [super initWithFrame:CGRectMake(0, 0, sizeToSet.width, sizeToSet.height)]) {
        [self commonInitWithSize:sizeToSet];
        
        self.defaultImageName = defaultImageName;
        self.imageURL = url;
    }
    
    return self;
}

- (id)initWithURL:(NSURL *)url {
    return [self initWithURL:url defaultImageName:nil imageSize:CGSizeZero];
}

- (id)initWithURL:(NSURL *)url withDefaultImageName:(NSString *)defaultImageName {
    return [self initWithURL:url defaultImageName:defaultImageName imageSize:CGSizeZero];
}

- (id)initWithURL:(NSURL *)url imageSize:(CGSize)size {
    return [self initWithURL:url defaultImageName:nil imageSize:size];
}

- (void)dealloc {
    [_imageView sd_cancelCurrentImageLoad];
    [_imageView removeFromSuperview];
}

#pragma mark - Private methods

- (void)commonInitWithSize:(CGSize)size {
    self.backgroundColor = RGB(204, 204, 204);
    
    // 图片显示
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageView];
    
    // 进度浮层
    _progressView = [[QQingProgressView alloc] init];
    _progressView.frame = CGRectMake((size.width - _progressView.frame.size.width) / 2,
                                     (size.height - _progressView.frame.size.width) / 2,
                                     _progressView.frame.size.width,
                                     _progressView.frame.size.height);
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_progressView];
    _progressView.hidden = YES;
    
    // 加载失败的浮层
    _loadingFailContentView = [[UIView alloc] init];
    _loadingFailContentView.frame = CGRectMake(0, 0, size.width, size.height);
    _loadingFailContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UILabel *retryTipLabel = [[UILabel alloc] initWithFrame:CGRectMake((size.width - 70) / 2, (size.height - 50) / 2, 70, 20)];
    retryTipLabel.text = @"加载失败";
    retryTipLabel.textAlignment = NSTextAlignmentCenter;
    retryTipLabel.font = [UIFont systemFontOfSize:15.0];
    retryTipLabel.textColor = RGB(255, 255, 255);
    [_loadingFailContentView addSubview:retryTipLabel];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retryButton.frame = CGRectMake((size.width - 70) / 2, (size.height - 50) / 2 + 30, 70, 20);
    retryButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [retryButton setTitle:@"点击重试" forState:UIControlStateNormal];
    [retryButton setBackgroundColor:RGB(240, 240, 240)];
    [retryButton setTitleColor:RGB(100, 100, 100) forState:UIControlStateNormal];
    [retryButton.layer setCornerRadius:10];
    [retryButton.layer setMasksToBounds:YES];
    
    [retryButton addTarget:self action:@selector(didClickRetryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_loadingFailContentView addSubview:retryButton];
    
    [self addSubview:_loadingFailContentView];
    _loadingFailContentView.hidden = YES;

    self.clipsToBounds = YES;
    self.supportFailRetry = YES;
    self.supportProgressIndicator = YES;
}

#pragma mark - Public methods

- (void)cancelRequest {
    [_imageView sd_cancelCurrentImageLoad];
}

#pragma mark -

- (void)setDefaultImageName:(NSString *)defaultImageName {
    _defaultImageName = defaultImageName;
    
    if (_defaultImageName) {
        self.imageView.image = [UIImage imageNamed:_defaultImageName];
    }
}

- (void)setImageURL:(NSURL *)url {
    _imageURL = url;
    
    if (self.supportFailRetry) {
        _loadingFailContentView.hidden = YES;
    }
    
    if (self.supportProgressIndicator) {
        _progressView.hidden = NO;
        _progressView.progress = 0;
    }
    
    __weak QQingImageView *weakSelf = self;
    [_imageView sd_setImageWithURL:_imageURL
                  placeholderImage:[UIImage imageNamed:_defaultImageName]
                           options:SDWebImageRetryFailed
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                              
                              if (weakSelf.supportProgressIndicator && (expectedSize > 0)) {
                                  [_progressView setProgress:((CGFloat)receivedSize) / expectedSize animated:YES];
                              }
                          } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              if (weakSelf.supportFailRetry && !image) {
                                  _loadingFailContentView.hidden = NO;
                              }
                              
                              if (weakSelf.supportProgressIndicator) {
                                  if (image) {
                                      _progressView.progress = 1;
                                  }
                                  _progressView.hidden = YES;
                              }
                              
                              if (image) {
                                  _imageView.image = image;
                              }

                              if ([weakSelf.finishRequestDelegate respondsToSelector:@selector(didFinishRequsetImageView:withState:)]) {
                                  [weakSelf.finishRequestDelegate didFinishRequsetImageView:weakSelf withState:(image != nil)];
                              }
                          }];
}

#pragma mark - IBAction

- (void)didClickRetryButtonAction:(UIButton *)sender {
    [self setImageURL:_imageURL];
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	self.isMove = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	self.isMove = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[event allTouches] count] == 1 && _loadingFailContentView.hidden && self.isMove == NO) {
        if ([self.singleClickDelegate respondsToSelector:@selector(didSingleClickImageView:)]) {
            [self.singleClickDelegate didSingleClickImageView:self];
        }
	}
}

@end
