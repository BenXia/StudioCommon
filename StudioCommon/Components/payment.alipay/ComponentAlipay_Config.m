//
//  ComponentAlipay_Config.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "ComponentAlipay_Config.h"

@implementation ComponentAlipay_Config

@def_singleton( ComponentAlipay_Config )

- (NSString *)showURL {
    return _showURL ? _showURL : @"m.alipay.com";
}

- (NSString *)service {
    return _service ? _service : @"mobile.securitypay.pay";
}

- (NSString *)paymentType {
    return _paymentType ? _paymentType : @"1";
}

- (NSString *)inputCharset {
    return _inputCharset ? _inputCharset : @"utf-8";
}

+ (instancetype)instance {
    return [ComponentAlipay_Config sharedInstance];
}

@end
