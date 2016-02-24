//
//  MultiPictureUploader.m
//  StudioCommon
//
//  Created by Ben on 16/2/24.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "MultiPictureUploader.h"
#import "PictureUploader.h"

@interface MultiPictureUploader ()

@property (nonatomic, strong) NSArray *imagesToUpload;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *uploadedImageUrls;

@property (nonatomic, copy) ArrayBlock successBlock;
@property (nonatomic, copy) ErrorBlock failBlock;

@property (nonatomic, strong) PictureUploader *uploader;

@end

@implementation MultiPictureUploader

- (void)uploadMultiImages:(NSArray*)uploadImages
          imageUploadType:(ImageUploadType)type
                  success:(ArrayBlock)successBlock
                     fail:(ErrorBlock)failBlock {
    self.imagesToUpload = uploadImages;
    self.currentIndex = 0;
    self.uploadedImageUrls = [NSMutableArray arrayWithCapacity:self.imagesToUpload.count];
    self.successBlock = successBlock;
    self.failBlock = failBlock;
    
    self.uploader = [[PictureUploader alloc] init];
    
    [self uploadImageAtIndex:self.currentIndex];
}

- (void)uploadImageAtIndex:(NSInteger)index {
    UIImage *imageToUpload = [self.imagesToUpload objectAtIndex:self.currentIndex];
    
    @weakify(self)
    [self.uploader uploadPicture:imageToUpload
                 imageUploadType:kImageUploadType_PhotoUploadType
                         success:^(NSString *imageUrl) {
                             @strongify(self)
                             self.currentIndex = self.currentIndex + 1;
                             if (imageUrl) {
                                 [self.uploadedImageUrls addObject:imageUrl];
                                 if (self.currentIndex == self.imagesToUpload.count) {
                                     self.successBlock(self.uploadedImageUrls);
                                 } else {
                                     [self uploadImageAtIndex:self.currentIndex];
                                 }
                             } else {
                                 self.failBlock(nil);
                             }
                         }
                            fail:^(NSError *error) {
                                @strongify(self)
                                self.failBlock(error);
                            }
                        progress:nil];
}

@end
