//
//  Component.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

/**
 *  @desc 该模块名为：component，借组件思想
 
 *  @class 基类Component，后续划分模块（事务、支付）继承该类，抽象统一的操作；最后所有的细分子模块都属于Component的衍生。
 */

#import <Foundation/Foundation.h>

@class Component;

/**
 *  全局的单例
 */
extern Component *component;

@interface Component : NSObject

@singleton( Component )

/**
 *  @desc 做一些外围的配置操作，不放到外围去配置
 */
+ (void)load;

/**
 *  @desc 功能开启
 
 *  做初始化工作
 */
+ (void)powerOn;

/**
 *  @desc 功能关闭
 
 *  做清理工作
 */
+ (void)powerOff;

@end

// ======== payment
#import "ComponentAlipay.h"
#import "ComponentAlipay_Config.h"
#import "ComponentAlipay_Order.h"

#import "ComponentWechatPay_Config.h"
#import "ComponentWechatPay_Order.h"
#import "ComponentWechatPay.h"

#pragma mark -

@package(Component, ComponentPayment,        payment)

/**
 *  举例：事务、日志、调试、权限控制
 */


