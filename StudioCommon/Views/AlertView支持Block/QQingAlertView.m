//
//  QQingAlertView.h
//  StudioCommon
//
//  Created by Ben on 8/7/15.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "QQingAlertView.h"

@implementation QQingAlertView {
    void (^_dismissBlock)(QQingAlertView *alertView, NSInteger dismissButtonIndex);
}

- (void)showWithDismissBlock:(void (^)(QQingAlertView *alertView, int dismissButtonIndex))dismissBlock {
    self.delegate = self;
    _dismissBlock = [dismissBlock copy];
    [self show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (_dismissBlock != NULL) {
        _dismissBlock((QQingAlertView *)alertView, buttonIndex);
    }
}

@end
