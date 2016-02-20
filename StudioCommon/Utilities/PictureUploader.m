//
//  PictureUploader.m
//  StudioCommon
//
//  Created by 王涛 on 16/2/20.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "PictureUploader.h"

@interface PictureUploader ()
@property (strong, nonatomic) UIImage *uploadImage;

@property (nonatomic,copy)ObjectBlock uploadSuccessBlock;
@property (nonatomic,copy)ErrorBlock uploadFailBlock;
@property (nonatomic,copy)FloatBlock uploadProgressBlock;

@end

@implementation PictureUploader

- (void)uploadHeadPicture:(UIImage *)picture imageUploadType:(ImageUploadType)type success:(ObjectBlock)success fail:(ErrorBlock)fail progress:(FloatBlock)progress {
    NSString *uploadHeadURL;
    self.uploadSuccessBlock = success;
    self.uploadFailBlock = fail;
    self.uploadProgressBlock = progress;
    switch (type) {
        case kImageUploadType_HeadimgUploadType: {
             uploadHeadURL = [NSString stringWithFormat:@"http://api.x.jiefangqian.com/?v=0.0.1&method=%@&auth=%@",@"user.set_avator",[UserCache sharedUserCache].token];
        }
            break;
        case kImageUploadType_PhotoUploadType: {
            uploadHeadURL = [NSString stringWithFormat:@"http://api.x.jiefangqian.com/?v=0.0.1&method=%@&auth=%@",@"user.upload",[UserCache sharedUserCache].token];
        }
            break;
            
        default:
            break;
    }
    [self uploadImagetoUrl:uploadHeadURL withImageUploadType:type];
}

-(void)uploadImagetoUrl:(NSString*)url withImageUploadType:(ImageUploadType)type{
    DDLogDebug(@"图片服务.上传URL:%@",url);
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //调整图片
    UIImage* realImage = [ImageUtil fixOrientation:self.uploadImage];
    //压缩图片
    NSData* imageData = [ImageUtil compressImageForUpload:realImage];
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n", MPboundary];
    //声明imagekey字段，文件名为boris.png
    switch (type) {
        case kImageUploadType_HeadimgUploadType:{
            [body appendFormat:@"Content-Disposition: form-data; name=\"avator\"; filename=\"picture.jpg\"\r\n"];
        }
            break;
        case kImageUploadType_PhotoUploadType:{
            [body appendFormat:@"Content-Disposition: form-data; name=\"img\"; filename=\"picture.jpg\"\r\n"];
        }
            break;
        default:
            break;
    }
    
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@", endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:imageData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@", TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%tu", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (!error) {
        NSError *errorPtr = nil;
        NSDictionary* resDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&errorPtr];
        if (errorPtr) {
            NSLog(@"图片服务上传解析失败");
            self.uploadFailBlock(error);
        } else {
            NSLog(@"图片服务上传成功");
            self.uploadSuccessBlock([resDict objectForKey:@"avator"]);
        }
    } else {
        NSLog(@"图片服务.上传失败%@",error);
        self.uploadFailBlock(error);
    }
    [self uploadDone];
}

#pragma mark - 回调

-(void)successCallBackWithResult:(id)result{
    if (self.uploadSuccessBlock) {
        __weak typeof(self) weakSelf = self;
        [[GCDQueue mainQueue]queueBlock:^{
            weakSelf.uploadSuccessBlock(result);
            [weakSelf uploadDone];
        }];
    }
}

-(void)errorCallBack:(NSError*)error{
    if (self.uploadFailBlock) {
        __weak typeof(self) weakSelf = self;
        [[GCDQueue mainQueue]queueBlock:^{
            weakSelf.uploadFailBlock(error);
            [weakSelf uploadDone];
        }];
    }
}

-(void)progressCallBack:(float)newProgress{
    //上传进度
    if (self.uploadProgressBlock) {
        __weak typeof(self) weakSelf = self;
        [[GCDQueue mainQueue]queueBlock:^{
            weakSelf.uploadProgressBlock(newProgress);
        }];
    }
}

#pragma mark - Private Method


- (void)uploadDone{
    self.uploadImage = nil;
    self.uploadFailBlock = nil;
    self.uploadProgressBlock = nil;
    self.uploadSuccessBlock = nil;
}


@end
