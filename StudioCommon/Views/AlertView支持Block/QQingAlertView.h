//
//  QQingAlertView.h
//  StudioCommon
//
//  Created by Ben on 8/7/15.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQingAlertView : UIAlertView <UIAlertViewDelegate>

- (void)showWithDismissBlock:(void (^)(QQingAlertView *alertView, int dismissButtonIndex))dismissBlock;

@end
