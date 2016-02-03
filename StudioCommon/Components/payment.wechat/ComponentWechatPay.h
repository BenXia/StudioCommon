//
//  ComponentWechatPay.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "ComponentPayment.h"

@class ComponentWechatPay_Order;
@class ComponentWechatPay_Config;

@interface ComponentWechatPay : ComponentPayment

@singleton( ComponentWechatPay ) // @singleton\prop_instance\error等作为模板

@prop_instance(ComponentWechatPay_Order, order)
@prop_instance(ComponentWechatPay_Config, config)

#pragma mark - Error

@error( err_WechatSucceed )
@error( err_WechatFailure )
@error( err_WechatCancel )
@error( err_WechatSentFail )
@error( err_WechatAuthDeny )
@error( err_WechatUnsupport )

#pragma mark - 

+ (BOOL)supported;

- (BOOL)pay;

- (void)process:(id)data;

@end
