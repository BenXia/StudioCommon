//
//  MultiPictureUploader.h
//  StudioCommon
//
//  Created by Ben on 16/2/24.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiPictureUploader : NSObject

- (void)uploadMultiImages:(NSArray*)uploadImages
          imageUploadType:(ImageUploadType)type
                  success:(ArrayBlock)successBlock
                     fail:(ErrorBlock)failBlock;

@end
