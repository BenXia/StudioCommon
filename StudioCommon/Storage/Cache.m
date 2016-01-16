//
//  Cache.m
//  StudioCommon
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "Cache.h"

@implementation Cache
static NSString *const kUserIDStringKey = @"kUserIDStringKey";
static NSString *const kSecondIDKey = @"kSecondIDKey";
static NSString *const UDStorageUserID                      = @"StorageUserID";
static NSString *const UDStorageBaseInfoUpdateTime          = @"StorageBaseInfoUpdateTime";

static NSString *const KWStorageUsername                    = @"StorageUsername";
static NSString *const KWStoragePassword                    = @"StoragePassword";
static NSString *const KWStorageNickname                    = @"StorageNickname";

SINGLETON_GCD(Cache);

// 保存用户名和密码
- (void)setUsername:(NSString *)username password:(NSString *)password {
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    [keychainStore removeItemForKey:KWStorageUsername];
    [keychainStore removeItemForKey:KWStoragePassword];
    [keychainStore setString:username forKey:KWStorageUsername];
    [keychainStore setString:password forKey:KWStoragePassword];
}

- (void)setUsername:(NSString *)username {
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    [keychainStore removeItemForKey:KWStorageUsername];
    [keychainStore setString:username forKey:KWStorageUsername];
}

- (NSString *)username {
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    return [keychainStore stringForKey:KWStorageUsername];
}

- (NSString *)password {
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    return [keychainStore stringForKey:KWStoragePassword];
}

- (void)setNickname:(NSString *)nickname{
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    [keychainStore removeItemForKey:KWStorageUsername];
    [keychainStore setString:nickname forKey:KWStorageNickname];
}

- (NSString *)nickname {
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    return [keychainStore stringForKey:KWStorageUsername];
}

- (void)setUserID:(long long)userID {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"UID"];
    [ud setObject:[NSNumber numberWithLongLong:userID] forKey:@"UID"];
    [ud synchronize];
}

- (long long)userID {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [ud objectForKey:@"UID"];
    if (value && ![value isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        return [value longLongValue];
    } else {
        return 0;
    }
}

- (void)setUserIDString:(NSString *)userIDString {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserIDStringKey];
    if (userIDString) {
        [ud setObject:userIDString forKey:kUserIDStringKey];
    } else {
        [ud setObject:@"" forKey:kUserIDStringKey];
        NSLog(@"调用setUserIDString:参数为nil");
    }
    [ud synchronize];
}

- (NSString *)userIDString {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:kUserIDStringKey];
}

- (void)setSecondId:(NSString *)secondId {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kSecondIDKey];
    [ud setObject:secondId forKey:kSecondIDKey];
    [ud synchronize];
}

- (NSString *)secondId {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:kSecondIDKey];
}

- (void)setIntroducedTeacherID:(long long)teacherId {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"teacher id"];
    [ud setObject:[NSNumber numberWithLongLong:teacherId] forKey:@"teacher id"];
    [ud synchronize];
}

- (long long)introducedTeacherID {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [ud objectForKey:@"teacher id"];
    if (value && ![value isEqualToNumber:[NSNumber numberWithLongLong:0]]) {
        return [value longLongValue];
    } else {
        return 0;
    }
}

- (void)setCookie:(BOOL)_isSignin {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"cookie"];
    [ud setObject:[NSNumber numberWithBool:_isSignin] forKey:@"cookie"];
    [ud synchronize];
}

- (BOOL)cookie {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *value = [ud objectForKey:@"cookie"];
    if (value && [value boolValue]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)setSessionId:(NSString *)sessionId {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"sessionId"];
    [ud setObject:sessionId forKey:@"sessionId"];
    [ud synchronize];
}

- (NSString *)sessionId {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"sessionId"];
}

- (void)setToken:(NSString *)token {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"token"];
    [ud setObject:token forKey:@"token"];
    [ud synchronize];
}

- (NSString *)token {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"token"];
}


// 用户手动退出或被踢后清除用户相关信息
- (void)resetUser {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    // 移除基础信息
    [ud removeObjectForKey:@"baseinfo"];
    // 移除已登录过标识
    [ud removeObjectForKey:@"cookie"];
    // 移除用户id
    [ud removeObjectForKey:@"UID"];
    // 移除String类型用户id
    [ud removeObjectForKey:kUserIDStringKey];
    // 移除推荐老师
    [ud removeObjectForKey:@"teacher id"];
    // 移除token
    [ud removeObjectForKey:@"token"];
    // 移除secondId
    [ud removeObjectForKey:kSecondIDKey];
    
    [ud synchronize];
    
    //移除钥匙串中信息
    UICKeyChainStore *keychainStore = [UICKeyChainStore keyChainStore];
    [keychainStore removeItemForKey:KWStorageUsername];
    [keychainStore removeItemForKey:KWStoragePassword];
}


@end
