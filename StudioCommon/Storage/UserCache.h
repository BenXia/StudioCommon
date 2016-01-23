//
//  Cache.h
//  StudioCommon
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCache : NSObject

+ (UserCache *)sharedUserCache;

// 保存用户名\密码\登录状态
- (void)setUsername:(NSString *)username password:(NSString *)password;
- (void)setUsername:(NSString *)username;

- (NSString *)username;
- (NSString *)password;

- (void)setNickname:(NSString *)nickname;
- (NSString *)nickname;

- (void)setUserID:(long long)userID;
- (long long)userID;

- (void)setUserIDString:(NSString *)userIDString;
- (NSString *)userIDString;

- (void)setSecondId:(NSString *)studentId;
- (NSString *)secondId;

- (void)setIntroducedTeacherID:(long long)teacherId;
- (long long)introducedTeacherID; // > 0 才有效

- (void)setCookie:(BOOL)_isSignin;
- (BOOL)cookie;

- (void)setSessionId:(NSString *)sessionId;
- (NSString *)sessionId;

- (void)setToken:(NSString *)token;
- (NSString *)token;


// 用户手动退出或被踢后清除用户相关信息
- (void)resetUser;



@end
