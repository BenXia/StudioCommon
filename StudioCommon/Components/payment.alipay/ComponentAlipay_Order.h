//
//  ComponentAlipay_Order.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComponentAlipay_Order : NSObject

@property (nonatomic, strong) NSString *no;         // 订单ID（由商家自行制定）
@property (nonatomic, strong) NSString *name;       // 商品标题
@property (nonatomic, strong) NSString *desc;       // 商品描述
@property (nonatomic, strong) NSString *price;      // 商品价格
@property (nonatomic, strong) NSString *outOfTime;

- (NSString *)generate:(NSError **)ppError;

- (void)clear;

#pragma mark - Error

@error( err_invalidOrderNumber )
@error( err_invalidProductName )
@error( err_failedGenerateOrder )

/**
 *  @desc 当前工程内实现，只关注下面参数
 */
@property (nonatomic, strong) NSString *payUrl;

- (NSString *)generate;

@end
