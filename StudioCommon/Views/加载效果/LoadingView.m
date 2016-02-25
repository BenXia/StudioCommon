//
//  LoadingView.m
//  StudioCommon
//
//  Created by 郭晓倩 on 16/2/25.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "LoadingView.h"


#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0
#define kWidthOfLoadingCircle 40

@interface LoadingView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation LoadingView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    //旋转视图
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = CGRectMake(0, 0, self.width, kWidthOfLoadingCircle);
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = [UIColor gray005Color].CGColor;
    
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    //加载中文字
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, kWidthOfLoadingCircle, self.width, self.height-kWidthOfLoadingCircle)];
    label.textColor = [UIColor gray005Color];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"加载中...";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
}

- (void)startAnimating {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    self.shapeLayer.lineWidth = 3;
    self.shapeLayer.lineCap = @"round";
    self.shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2,kWidthOfLoadingCircle/2)
                                                          radius:kWidthOfLoadingCircle/2 - 1
                                                      startAngle:DEGREES_TO_RADIANS(348)
                                                        endAngle:DEGREES_TO_RADIANS(12)
                                                       clockwise:NO].CGPath;
    self.shapeLayer.strokeEnd = 1;
    
    [CATransaction commit];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotationAnimation.duration = 1.0;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.shapeLayer addAnimation:rotationAnimation forKey:@"indeterminateAnimation"];
}

- (void)stopAnimating {
    [self.shapeLayer removeAnimationForKey:@"indeterminateAnimation"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}


@end
