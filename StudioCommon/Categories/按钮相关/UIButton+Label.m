//
//  UIButton+Label.m
//  StudioCommon
//
//  Created by Ben on 2/2/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "UIButton+Label.h"

@implementation UIButton (Label)

- (NSString *)getLabelText{
    NSArray *arr = self.subviews;
    UILabel *label;
    for (int i = 0; i<arr.count; i++) {
        if ([arr[i] isKindOfClass:[UILabel class]]) {
            label = arr[i];
        }
    }
    return label.text;
}

- (void)centerImageAndTitleWithSpace:(float)spacing {
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}

- (void)centerImageAndTitle {
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitleWithSpace:DEFAULT_SPACING];
}

@end
