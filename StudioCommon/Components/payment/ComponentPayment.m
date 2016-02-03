//
//  ComponentPayment.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "ComponentPayment.h"
#import "ComponentAlipay.h"

@implementation ComponentPayment

@def_singleton( ComponentPayment )

@def_error(err_Succeed, kErrorCodePaymentSucceed, @"订单支付成功")
@def_error(err_Failure, kErrorCodePaymentFailure, @"订单支付失败")
@def_error(err_Cancel, kErrorCodePaymentCancel, @"订单支付取消")
@def_error(err_Uninstalled, kErrorCodePaymentUninstalled, @"指定第三方支付软件未安装正确")

@def_notification( WAITTING )
@def_notification( SUCCEED )
@def_notification( FAILED )

#pragma mark - Supported

+ (BOOL)supported {
    return YES;
}

#pragma mark - State notifier

- (void)notifyWaiting:(NSNumber *)progress {
    [self postNotification:ComponentPayment.WAITTING];
    
    if ( self.waitingHandler ) {
        self.waitingHandler(progress);
    }
}

- (void)notifySucceed:(id)result {
    [self postNotification:ComponentPayment.SUCCEED];
    
    if ( self.succeedHandler ) {
        self.succeedHandler(result);
    }
}

- (void)notifyFailed:(NSError *)error {
    [self postNotification:ComponentPayment.FAILED];
    
    if ( self.failedHandler ) {
        self.failedHandler(error);
    }
}

- (void)notifyUnknown {
    [UIUtils showAlertView:@"注意" :@"未知错误，请联系售后，轻轻竭诚为您服务" :@"好"];
}

#pragma mark - Declaration

- (BOOL)pay {
    return NO;
}

- (void)process:(id)data {
    
}

@end

#pragma mark - 

@def_package(ComponentPayment, ComponentAlipay, alipay)
@def_package(ComponentPayment, ComponentWechatPay, wechatpay)

