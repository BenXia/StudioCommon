//
//  ComponentAlipay.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <AlipaySDK/AlipaySDK.h>

#import "ComponentAlipay.h"
#import "ComponentAlipay_Config.h"
#import "ComponentAlipay_Order.h"

#pragma mark - 支付宝

@implementation ComponentAlipay

@def_singleton( ComponentAlipay )

@def_prop_instance(ComponentAlipay_Order, order)
@def_prop_instance(ComponentAlipay_Config, config)

@def_error( err_AliSucceed, kAlipayErrorCode_Succeed, @"支付宝支付成功" )
@def_error( err_AliDealing, kAlipayErrorCode_Dealing, @"")
@def_error( err_AliFailure, kAlipayErrorCode_Failed, @"支付宝支付失败" )
@def_error( err_AliCancel, kAlipayErrorCode_Cancel, @"支付宝 支付订单取消" )
@def_error( err_AliNetError, kAlipayErrorCode_NetError, @"")

- (BOOL)pay {
//    NSError *error = nil;
    
    NSString *appSchema = [AppSystem appSchema:@"alipay"];
    if (! appSchema) {
        appSchema = [AppSystem appSchema];
        if (! appSchema) {
            self.errorCode = kErrorCodePaymentInvalidData;
            self.errorDesc = @"订单数据无效";
            
            [self notifyFailed:self.error];
            
            return NO;
        }
    }
    
    NSString *orderString = [[self order] generate];
    if (! orderString) {
        self.errorCode = kErrorCodePaymentInvalidData;
        self.errorDesc = @"订单数据无效";
        
        [self notifyFailed:self.error];
        
        return NO;
    }
    
    AlipaySDK *sdk = [AlipaySDK defaultService];
    if (! sdk) {
        self.errorCode = kErrorCodePaymentUninstalled;
        self.errorDesc = @"请先安装支付宝";
        
        [self notifyFailed:self.error];
        
        return NO;
    }
    
    [sdk payOrder:orderString
       fromScheme:appSchema
         callback:^(NSDictionary *resultDic) {
             [self process:resultDic];
         }];
    
    [self notifyWaiting:@(0)];
    
    return YES;
}

- (void)process:(id)data {
    NSDictionary *resultDict    = data;
    __unused NSString *memo     = [resultDict objectForKey:@"memo"];
    __unused NSString *result   = [resultDict objectForKey:@"result"];
    NSNumber *status            = [resultDict objectForKey:@"resultStatus"];

    self.errorCode = [status intValue];

    switch ([status intValue]) {
        case kAlipayErrorCode_Succeed: {
            self.errorDesc = @"支付宝支付成功";
            
            [self notifySucceed:self];
        }
            break;
            
        case kAlipayErrorCode_Dealing: {
            self.errorDesc = @"支付订单正在处理中";
            
            [self notifyWaiting:@(50)];
        }
            break;
            
        case kAlipayErrorCode_Failed: {
            self.errorDesc = @"支付宝支付失败";
            
            [self notifyFailed:self.error];
        }
            break;
            
        case kAlipayErrorCode_Cancel: {
            self.errorDesc = @"支付宝 支付订单取消";
            
            [self notifyFailed:self.error];
        }
            break;
            
        case kAlipayErrorCode_NetError: {
            self.errorDesc = @"网络连接失败";
            
            [self notifyFailed:self.error];
        }
            
        default: {
            self.errorDesc = @"unknown";
            
            [self notifyFailed:self.error];
        }
            break;
    }
}

#pragma mark - Parse

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    if (url != nil && [[url host] compare:@"safepay"] == 0) { // AlixPayment result
        
        // 以防万一：2.0
        [[AlipaySDK defaultService] processAuth_V2Result:url
                                         standbyCallback:^(NSDictionary *resultDic) {
                                             //                                             QQLog(@"result = %@",resultDic);
                                             //                                             NSString *resultStr = resultDic[@"result"];
                                             
                                             
                                         }];
        // 以防万一：
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //                                                      QQLog(@"result = %@",resultDic);
                                                      //                                                      NSString *resultStr = resultDic[@"result"];
                                                  }];
    }
}

#pragma mark - Property

- (NSError *)error {
    NSError *err    = [NSError errorWithDomain:@"alipay" code:self.errorCode userInfo:@{@"desc":self.errorDesc}];
    
    if ([err is:self.err_AliCancel]) {
        return self.err_Cancel;
    } else if ([err is:self.err_AliSucceed]) {
        return self.err_Succeed;
    } else {
        return self.err_Failure;
    }
}

@end
