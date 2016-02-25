//
//  ShareParamBuilder.h
//  QQingCommon
//
//  Created by fallen.ink on 12/21/15.
//  Copyright © 2015 QQingiOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareParamBuilder : NSObject

@property (nonatomic, strong) NSString * channelId;

// ======== 以下为分享的外部模块所需参数

@property (nonatomic, copy) NSString *title;                // 标题
@property (nonatomic, copy) NSString *detail;               // 摘要
@property (nonatomic, copy) NSString *url;                  // URL
@property (nonatomic, strong) UIImage *image;               // 图片
@property (nonatomic, copy) NSString *objectId;             // 微博 required


- (NSDictionary *)getParam;

// ================= 目标 字典 ====== 暂时用不到

- (NSDictionary *)getWechatFriendParam; // 微信朋友：

- (NSDictionary *)getWechatFriendCircleParam; // 微信朋友圈：

- (NSDictionary *)getWeiboParam; // 微博：

- (NSDictionary *)getQQParam; // qq朋友：

- (NSDictionary *)getQQSpaceParam; // qq空间：

- (NSDictionary *)getSmsParam; // 短信：

- (NSDictionary *)getEmailParam; // 邮件：

- (NSDictionary *)getUrlCopy; // 拷贝链接：url only（仅仅是统一调用方式）


@end
