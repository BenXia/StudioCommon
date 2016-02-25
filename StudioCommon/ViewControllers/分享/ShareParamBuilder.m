//
//  ShareParamBuilder.m
//  QQingCommon
//
//  Created by fallen.ink on 12/21/15.
//  Copyright © 2015 QQingiOSTeam. All rights reserved.
//

#import "ShareParamBuilder.h"

#define kShareTitle          @"TitleString"         //分享链接,邮件Title
#define kShareDetail         @"DetailString"        //分享链接的description
#define kShareUrl            @"ShareUrl"            //分享链接的URL
#define kShareImage          @"ShareImage"          //分享链接的image
#define kShareMessageText    @"ShareMessageText"    //分享的内容。微博，qq，短信，邮件需要填写的内容
#define kObjectID            @"ObjectID"            //微博分享使用唯一标识

@interface ShareParamBuilder ()

@end

@implementation ShareParamBuilder

- (instancetype)init {
    if (self = [super init]) {
    
    }
    
    return self;
}

#pragma mark - Builder

- (NSDictionary *)getParam {
    NSAssert(self.title, @"share title nil");
    NSAssert(self.detail, @"share detail nil");
    NSAssert(self.url, @"share url nil");
    NSAssert(self.image, @"share image nil");
    NSAssert(self.objectId, @"share objectId nil");
    
    return @{kShareTitle:self.title,
             kShareDetail:self.detail,
             kShareUrl:self.url,
             kShareImage:self.image,
             kObjectID:self.objectId};
}

- (NSDictionary *)getWechatFriendParam {
    return nil;
}

- (NSDictionary *)getWechatFriendCircleParam {
    return nil;
}

- (NSDictionary *)getWeiboParam {
    return nil;
}

- (NSDictionary *)getQQParam {
    return nil;
}

- (NSDictionary *)getQQSpaceParam {
    return nil;
}

- (NSDictionary *)getSmsParam {
    return nil;
}

- (NSDictionary *)getEmailParam {
    return nil;
}

- (NSDictionary *)getUrlCopy {
    NSAssert(self.url, @"share url nil");
    
    return @{@"kShareUrl":self.url};
}

#pragma mark - tool

- (NSString*)finalShareUrlStringByAddingChnid:(NSString*)originalString {
    NSString* chnid = self.channelId;
    NSString* chnidParams = @"";
    NSString* finalShareURL = nil;
    NSRange questionRange = [originalString rangeOfString:@"?"];
    NSRange numberRange = [originalString rangeOfString:@"#"];
    if (questionRange.location != NSNotFound) {
        chnidParams = [chnidParams stringByAppendingString:[NSString stringWithFormat:@"?chnid=%@&", chnid]];
        finalShareURL = [originalString stringByReplacingCharactersInRange:questionRange withString:chnidParams];
    } else if (numberRange.location != NSNotFound) {
        chnidParams = [chnidParams stringByAppendingString:[NSString stringWithFormat:@"?chnid=%@#", chnid]];
        finalShareURL = [originalString stringByReplacingCharactersInRange:numberRange withString:chnidParams];
    } else {
        finalShareURL = [originalString stringByAppendingString:[NSString stringWithFormat:@"?chnid=%@", chnid]];
    }
    
    return finalShareURL;
}

#pragma mark - Property

- (NSString *)url {
    return [self finalShareUrlStringByAddingChnid:_url];
}

@end
