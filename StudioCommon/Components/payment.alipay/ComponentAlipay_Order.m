//
//  ComponentAlipay_Order.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "Order.h"
#import "DataSigner.h"

#import "ComponentAlipay_Order.h"
#import "ComponentAlipay_Config.h"

@implementation ComponentAlipay_Order

- (NSString *)generate:(NSError **)ppError {
    Order *order = [Order new];
    
    order.partner   = [ComponentAlipay_Config sharedInstance].parnter;
    order.seller    = [ComponentAlipay_Config sharedInstance].seller;
    order.notifyURL = [ComponentAlipay_Config sharedInstance].notifyURL;
    
    order.showUrl   = [ComponentAlipay_Config sharedInstance].showURL;
    order.service   = [ComponentAlipay_Config sharedInstance].service;
    order.paymentType   = [ComponentAlipay_Config sharedInstance].paymentType;
    order.inputCharset  = [ComponentAlipay_Config sharedInstance].inputCharset;
    
    if (self.no && self.no.length) {
        order.tradeNO = self.no;
    } else {
        *ppError    = [self err_invalidOrderNumber];
        
        return nil;
    }
    
    if (self.name && self.name.length) {
        order.productName = self.name;
    } else {
        *ppError    = [self err_invalidProductName];
        
        return nil;
    }
    
    if (self.desc && self.desc.length) {
        order.productDescription = self.desc;
    } else {
        order.productDescription = @"unknown";
    }
    
    if (self.price && self.price.length) {
        order.amount = self.price;
    } else {
        order.amount = @"0.00";
    }
    
    if(self.outOfTime && self.outOfTime.length) {
        order.itBPay = self.outOfTime;  // 格式yyyy-MM-dd HH:mm:ss（5月26号后）
                                        // m-分钟，h－小时，d－天，1c－当天，范围：1m－15d （5月26号之前）
    }
    
    NSString *orderDesc = [order description];
    id<DataSigner> signer = CreateRSADataSigner([ComponentAlipay_Config sharedInstance].privateKey);
    
    NSString *signedString  = [signer signString:orderDesc];
    if (!signedString) {
        *ppError    = [self err_failedGenerateOrder];
        
        return nil;
    }
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderDesc, signedString, @"RSA"];
    if (!orderString ||
        !orderString.length ) {
        return nil;
    }
    
    return orderString;
}

- (NSString *)generate {
    return self.payUrl;
}

- (void)clear {
    self.no = nil;
    self.name = nil;
    self.desc = nil;
    self.price = nil;
}

#pragma mark - Error

@def_error_2( err_invalidOrderNumber, 1000, @"Invalid order number!" )
@def_error_2( err_invalidProductName, 1001, @"Invalid product name!" )
@def_error_2( err_failedGenerateOrder, 1002, @"failed to generate order string" )

@end
