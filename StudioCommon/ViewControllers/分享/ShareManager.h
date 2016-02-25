//
//  ShareManager.h
//  StudioCommon
//
//  Created by 王涛 on 16/2/25.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG

#define kAssistantCardURLString @"http://www.baidu.com"
#define kOfficialWensiteURLString @"http://www.baidu.com"

#else

#define kAssistantCardURLString @"http://www.baidu.com"
#define kOfficialWensiteURLString @"http://www.baidu.com"

#endif

typedef enum {
    kShare_WeiXinFriends = 0,   // 微信好友
    kShare_WeiXinCircleFriends, // 微信朋友圈
    kShare_Sina                 // 新浪
} ShareType;

@class ShareActivityVC;
extern ShareActivityVC *g_popupShareActivityVC;
@class ShareParamBuilder;

@interface ShareManager : NSObject

/**
 *  用ShareParamBuilder初始化
 */
+ (void)shareWithWithParamBuilder:(ShareParamBuilder *)paramBuilder
                        shareType:(ShareType)shareType;

@end
