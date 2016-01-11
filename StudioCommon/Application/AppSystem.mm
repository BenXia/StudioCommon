//
//  AppSystem.m
//  StudioCommon
//
//  Created by Ben on 5/22/15.
//
//
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <stdlib.h>
#import "AppSystem.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
const BOOL IOS9_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending );
const BOOL IOS8_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending );
const BOOL IOS7_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending );
const BOOL IOS6_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending );
const BOOL IOS5_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending );
const BOOL IOS4_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending );
const BOOL IOS3_OR_LATER = ( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending );

const BOOL IOS8_OR_EARLIER = !IOS9_OR_LATER;
const BOOL IOS7_OR_EARLIER = !IOS8_OR_LATER;
const BOOL IOS6_OR_EARLIER = !IOS7_OR_LATER;
const BOOL IOS5_OR_EARLIER = !IOS6_OR_LATER;
const BOOL IOS4_OR_EARLIER = !IOS5_OR_LATER;
const BOOL IOS3_OR_EARLIER = !IOS4_OR_LATER;

const BOOL IS_SCREEN_4_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO);
const BOOL IS_SCREEN_35_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO);
const BOOL IS_SCREEN_47_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO);
const BOOL IS_SCREEN_55_INCH = ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO);
#else
const BOOL IOS9_OR_LATER = NO;
const BOOL IOS8_OR_LATER = NO;
const BOOL IOS7_OR_LATER = NO;
const BOOL IOS6_OR_LATER = NO;
const BOOL IOS5_OR_LATER = NO;
const BOOL IOS4_OR_LATER = NO;
const BOOL IOS3_OR_LATER = NO;

const BOOL IOS8_OR_EARLIER = NO;
const BOOL IOS7_OR_EARLIER = NO;
const BOOL IOS6_OR_EARLIER = NO;
const BOOL IOS5_OR_EARLIER = NO;
const BOOL IOS4_OR_EARLIER = NO;
const BOOL IOS3_OR_EARLIER = NO;

const BOOL IS_SCREEN_35_INCH = NO;
const BOOL IS_SCREEN_4_INCH = NO;
const BOOL IS_SCREEN_47_INCH = NO;
const BOOL IS_SCREEN_55_INCH = NO;
#endif


@implementation AppSystem

+ (NSString *)OSVersion {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appVersion {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_MAC)
    static NSString *bundleVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    });
    
    return bundleVersion;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appIdentifier {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    static NSString * __identifier = nil;
    if ( nil == __identifier ) {
        __identifier = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    }
    return __identifier;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return @"";
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)appSchema {
    return [self appSchema:nil];
}

+ (NSString *)appSchema:(NSString *)name {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSArray * array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    for ( NSDictionary * dict in array ) {
        if ( name ) {
            NSString * URLName = [dict objectForKey:@"CFBundleURLName"];
            if ( nil == URLName ) {
                continue;
            }
            
            if ( NO == [URLName isEqualToString:name] ) {
                continue;
            }
        }
        
        NSArray * URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
        if ( nil == URLSchemes || 0 == URLSchemes.count ) {
            continue;
        }
        
        NSString * schema = [URLSchemes objectAtIndex:0];
        if ( schema && schema.length )
        {
            return schema;
        }
    }
    
    return nil;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

+ (NSString *)deviceModel {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return [UIDevice currentDevice].model;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    return nil;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
//    int mib[2];
//    size_t len;
//    char *machine;
//    
//    mib[0] = CTL_HW;
//    mib[1] = HW_MACHINE;
//    sysctl(mib, 2, NULL, &len, NULL, 0);
//    machine =(char *) malloc(len);
//    sysctl(mib, 2, malloc(len), &len, NULL, 0);
//    
//    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
//    free(machine);
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *answer = (char *)(malloc(size));
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);

    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

+ (NSString *)bundleID {
    NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    return bundleID;
}

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
static const char * __jb_app = NULL;
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

+ (BOOL)isJailBroken NS_AVAILABLE_IOS(4_0) {
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    static const char * __jb_apps[] = {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    __jb_app = NULL;
    
    // method 1
    for ( int i = 0; __jb_apps[i]; ++i ) {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] ) {
            __jb_app = __jb_apps[i];
            return YES;
        }
    }
    
    // method 2
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] ) {
        return YES;
    }
    
    // method 3
    if ( 0 == system("ls") ) {
        return YES;
    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}

+ (NSString *)jailBreaker NS_AVAILABLE_IOS(4_0) {
#if (TARGET_OS_IPHONE)
    if ( __jb_app ) {
        return [NSString stringWithUTF8String:__jb_app];
    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return @"";
}

@end

@implementation AppSystem (SystemCall)

+ (void)makePhonecall:(NSString *)telnum {
    if (!telnum || (telnum.length == 0)) {
        return;
    }
    
    NSString *phoneNumberString = [telnum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phoneNumberString != nil) {
        NSString *urlStr = [[NSString alloc] initWithFormat:@"telprompt://%@", phoneNumberString];
        BOOL isSuccess = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        if (!isSuccess) {
            NSLog(@"拨打电话失败:%@", urlStr);
        }
    }
}

@end
