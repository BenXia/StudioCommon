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
- (void)uploadPicture:(UIImage *)picture
      imageUploadType:(ImageUploadType)imageUploadType
              success:(StringBlock)successBlock
                 fail:(ErrorBlock)failBlock
             progress:(FloatBlock)progressBlock ;

@end
