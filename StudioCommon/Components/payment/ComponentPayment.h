//
//  ComponentPayment.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "Component.h"

typedef NS_ENUM(NSInteger, PaymentErrorCode) {
    // mainly
    kErrorCodePaymentSucceed        = 0,
    kErrorCodePaymentFailure        = -10,
    kErrorCodePaymentCancel         = -20,
    kErrorCodePaymentUninstalled    = -30,
    
    // 前置错误（未实际调用api）
    kErrorCodePaymentInvalidData    = -40,
    kErrorCodePaymentSignature      = -50,
};

@interface ComponentPayment : Component

@singleton( ComponentPayment )

/**
 *  @desc 最近一次错误的实际原因（子类中）
 
 *  @error 而handler中传的错误是通用错误（ComponentPayment中声明）
 */
@property (nonatomic, assign) NSUInteger    errorCode; // 调试版本使用
@property (nonatomic, copy)   NSString *    errorDesc; // 调试版本使用

@property (nonatomic, copy) ObjectBlock     waitingHandler;
@property (nonatomic, copy) ObjectBlock     succeedHandler;
@property (nonatomic, copy) ErrorBlock      failedHandler; // 支付错误、支付取消

/**
 *  支付成功，不区分qqing支付、第三方支付
 */
@error( err_Succeed )
/**
 *  支付失败，不区分qqing支付、第三方支付
 */
@error( err_Failure )
/**
 *  第三方支付取消
 */
@error( err_Cancel )
/**
 *  指定的第三方支付没有安装
 */
@error( err_Uninstalled )

/**
 *  NSNumber
 */
@notification( WAITTING )

/**
 *  携带必要的应答对象
 */
@notification( SUCCEED )

/**
 *  携带错误对象
 
 *  NSError
 */
@notification( FAILED )

/**
 *  @desc 是否支持该支付方式
 */
+ (BOOL)supported;

// Tool methods
- (void)notifyWaiting:(NSNumber *)progress;
- (void)notifySucceed:(id)result; // 当前：携带err_Succeed
- (void)notifyFailed:(NSError *)error;
- (void)notifyUnknown; // 未知情况

// Overrided
- (BOOL)pay; // @return 不可不必处理，错误处理在failedHandler
- (void)process:(id)data;

@end

#pragma mark -

@package(ComponentPayment, ComponentAlipay, alipay)
@package(ComponentPayment, ComponentQqingpay, qqingpay)
@package(ComponentPayment, ComponentWechatPay, wechatpay)
@package(ComponentPayment, ComponentUnionPay, unionPay)

