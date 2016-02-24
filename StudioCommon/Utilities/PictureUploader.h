//
//  PictureUploader.h
//  StudioCommon
//
//  Created by 王涛 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kImageUploadType_HeadimgUploadType = 1,
    kImageUploadType_PhotoUploadType = 2,
} ImageUploadType;

@interface PictureUploader : NSObject

// 上传头像
- (void)uploadHeadPicture:(UIImage*)picture imageUploadType:(ImageUploadType)type success:(ObjectBlock)success fail:(ErrorBlock)fail progress:(FloatBlock)progress;

@end
