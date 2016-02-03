//
//  ComponentWechatPay_Order.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComponentWechatPay_Order : NSObject

@property (nonatomic, copy) NSString *  prepayId;
@property (nonatomic, copy) NSString *  nonceStr;
@property (nonatomic, assign) uint32_t  timeStamp;
@property (nonatomic, copy) NSString *  package;
@property (nonatomic, copy) NSString *  sign;

@end
