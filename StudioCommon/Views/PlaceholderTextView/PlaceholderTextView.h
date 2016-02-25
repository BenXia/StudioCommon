//
//  PlaceholderTextView.h
//  StudioCommon
//
//  Created by Ben on 8/6/15.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PlaceholderType) {
    PlaceholderType_Left,
    PlaceholderType_Middel,
    PlaceholderType_Right
};


@interface PlaceholderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, assign) PlaceholderType placeholderType;

@end
