//
//  AppSystem.h
//  QQing
//
//  Created by 李杰 on 5/22/15.
//
//

#import <Foundation/Foundation.h>

extern const BOOL IOS9_OR_LATER;
extern const BOOL IOS8_OR_LATER;
extern const BOOL IOS7_OR_LATER;
extern const BOOL IOS6_OR_LATER;
extern const BOOL IOS5_OR_LATER;
extern const BOOL IOS4_OR_LATER;
extern const BOOL IOS3_OR_LATER;

extern const BOOL IOS8_OR_EARLIER;
extern const BOOL IOS7_OR_EARLIER;
extern const BOOL IOS6_OR_EARLIER;
extern const BOOL IOS5_OR_EARLIER;
extern const BOOL IOS4_OR_EARLIER;
extern const BOOL IOS3_OR_EARLIER;

extern const BOOL IS_SCREEN_4_INCH;
extern const BOOL IS_SCREEN_35_INCH;
extern const BOOL IS_SCREEN_47_INCH;
extern const BOOL IS_SCREEN_55_INCH;


@interface AppSystem : NSObject

+ (NSString *)OSVersion;
+ (NSString *)appVersion;
+ (NSString *)appIdentifier;
+ (NSString *)appSchema;
+ (NSString *)appSchema:(NSString *)name;
+ (NSString *)deviceModel;
+ (NSString *)getCurrentDeviceModel;
+ (NSString *)bundleID;

+ (BOOL)isJailBroken		NS_AVAILABLE_IOS(4_0);
+ (NSString *)jailBreaker	NS_AVAILABLE_IOS(4_0);

//+ (BOOL)isDevicePhone;
//+ (BOOL)isDevicePad;

//+ (BOOL)requiresPhoneOS;

@end

/**
 *  系统调用
 
 *  打电话之类的。。。。
 */
@interface AppSystem (SystemCall)

+ (void)makePhonecall:(NSString *)telnum;

@end


