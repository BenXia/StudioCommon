//
//  ComponentAlipay.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "ComponentPayment.h"

@class ComponentAlipay_Config;
@class ComponentAlipay_Order;

typedef NS_ENUM(NSInteger, AlipayErrorCode) {
    // 支付成功
    kAlipayErrorCode_Succeed = 9000,
    // 支付订单正在处理中
    kAlipayErrorCode_Dealing = 8000,
    // 支付失败
    kAlipayErrorCode_Failed = 4000,
    // 支付订单被取消
    kAlipayErrorCode_Cancel = 6001,
    // 网络连接失败
    kAlipayErrorCode_NetError = 6002,
};

@interface ComponentAlipay : ComponentPayment

@singleton( ComponentAlipay )

@prop_instance(ComponentAlipay_Order, order)
@prop_instance(ComponentAlipay_Config, config)

#pragma mark - Error

@error( err_AliSucceed )
@error( err_AliDealing )
@error( err_AliFailure )
@error( err_AliCancel )
@error( err_AliNetError )

#pragma mark - 

- (BOOL)pay;
- (void)process:(id)data;

- (void)parse:(NSURL *)url application:(UIApplication *)application;

@end