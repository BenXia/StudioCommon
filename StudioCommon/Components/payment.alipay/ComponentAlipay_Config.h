//
//  ComponentAlipay_Config.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComponentAlipay_Config : NSObject

@singleton( ComponentAlipay_Config )

@property (nonatomic, strong) NSString *parnter;
@property (nonatomic, strong) NSString *seller;
@property (nonatomic, strong) NSString *privateKey;
@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *notifyURL;      // 回调URL

// Downby should be const.
@property (nonatomic, strong) NSString *showURL;
@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *paymentType;
@property (nonatomic, strong) NSString *inputCharset;

@end
