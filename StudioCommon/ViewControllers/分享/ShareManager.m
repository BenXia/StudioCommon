//
//  ShareManager.m
//  StudioCommon
//
//  Created by 王涛 on 16/2/25.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "ShareManager.h"
#import "WXApi.h"
#import "ShareParamBuilder.h"

#define kRedirectURI           @"http://www.sina.com"

@interface ShareManager ()<
WXApiDelegate
>

// 分享参数
@property (nonatomic, strong) NSString *objectID;//微博分享使用唯一标识
@property (nonatomic, strong) NSString *sharePhone;//短信分享的电话
@property (nonatomic, strong) NSString *shareEmail;//邮件分享的邮箱
@property (nonatomic, strong) NSString *shareTitle;//分享链接的Title
@property (nonatomic, strong) NSString *shareDetail;//分享链接的description
@property (nonatomic, strong) NSString *shareURL;//分享链接的URL
@property (nonatomic, strong) NSString *shareShortURL; //最终分享的短链接
@property (nonatomic, strong) UIImage *shareImage;//分享链接的image
@property (nonatomic, strong) NSString *shareFrom;//区别两个端
@property (nonatomic, strong) NSString *viewTitle;//shareView上的Title

@end

@implementation ShareManager

#pragma mark - Pulbic methods

+ (void)shareWithWithParamBuilder:(ShareParamBuilder *)paramBuilder shareType:(ShareType)shareType {
    switch (shareType) {
        case kShare_WeiXinCircleFriends: {
            [self sendBuilder:paramBuilder WithType:kShare_WeiXinCircleFriends];
        }
            break;
        case kShare_WeiXinFriends: {
            [self sendBuilder:paramBuilder WithType:kShare_WeiXinFriends];
        }
            break;
        case kShare_Sina: {
            [self sendSinaWeiBoWith:paramBuilder];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Utilities

+ (NSData*)compressThumbImage:(UIImage*)desImage {
    NSData* thumbData = nil;
    if (desImage) {
        UIImage* thumbImg = [self scaleToSize:desImage size:CGSizeMake(150, 150)];
        //缩略图数据大小不能超过32K
        float compressRate = 1.0f;
        thumbData = UIImageJPEGRepresentation(thumbImg, compressRate);
        while(thumbData.length > 32*1024) {
            compressRate = compressRate * 0.5;
            thumbData = UIImageJPEGRepresentation(thumbImg, compressRate);
            if(compressRate < 0.1)
                break;
        }
    }
    DDLogInfo(@"微信缩略图大小%tu", thumbData.length);
    return thumbData;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - 微信

+ (void)sendBuilder:(ShareParamBuilder *)builder WithType:(ShareType)type {
    if (![WXApi isWXAppInstalled]) {
        [Utilities showToastWithText:@"分享.微信未安装"];
        return;
    }
    
    if (![WXApi isWXAppSupportApi]) {
        [Utilities showToastWithText:@"分享.当前微信的版本不支持"];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = builder.title;
    message.description = builder.detail;
    
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = builder.url;
    message.mediaObject = webObj;
    
    if (builder.image) {
        message.thumbData = [self compressThumbImage:builder.image];
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    int scene = 0;
    switch (type) {
        case kShare_WeiXinFriends: {
            scene = WXSceneSession;
        }
            break;
        case kShare_WeiXinCircleFriends: {
            scene = WXSceneTimeline;
        }
            break;
        default:
            break;
    }
    
    req.scene = scene;
    req.bText = NO;
    req.message = message;
    BOOL ret = [WXApi sendReq:req];
    if (ret == NO) {
        [Utilities showToastWithText:@"分享.分享失败"];
    }
}

#pragma mark - 新浪微博

+ (void)sendSinaWeiBoWith:(ShareParamBuilder *)builder {
    //    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    //    authRequest.redirectURI = kRedirectURI;
    //    authRequest.scope = @"all";
    //
    //    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:nil];
    //    request.userInfo = @{@"ShareMessageFrom": @"ShareActivityVC"};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    //    [WeiboSDK sendRequest:request];
    //    [self dismissSharePopup];
    //}
    //
    //- (WBMessageObject *)messageToShare {
    //    if ([WeiboSDK isCanShareInWeiboAPP] && [WeiboSDK isWeiboAppInstalled]) {
    //
    //        WBMessageObject *message = [WBMessageObject message];
    //        message.text = [NSString stringWithFormat:@"%@%@ @轻轻家教", self.paramBuilder.title, self.paramBuilder.detail];
    //        WBWebpageObject *webpage = [WBWebpageObject object];
    //        webpage.objectID = self.objectID;
    //        webpage.title = self.shareTitle;
    //        webpage.description = self.shareDetail;
    //        webpage.thumbnailData = [self compressThumbImage:self.shareImage];
    //        webpage.webpageUrl = self.shareURL;
    //        message.mediaObject = webpage;
    //        return message;
    //    } else {
    //        WBMessageObject *message = [WBMessageObject message];
    //        message.text = [NSString stringWithFormat:@"%@%@ @轻轻家教", self.paramBuilder.title, self.paramBuilder.detail];
    //        return message;
    //    }
}
@end
