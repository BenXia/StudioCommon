//
//  ArchiveRecord.h
//  QQing
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//  Encode/Decode object(implement NSCoding/NSCopying proto) by NSKeyedArchiver/NSKeyedUnarchiver

#import <Foundation/Foundation.h>

@interface ArchiveRecord : NSObject

+ (void)saveObject:(id)codeable asFilename:(NSString *)fn;

+ (id)fetchWithFilename:(NSString *)fn;

+ (void)deleteWithFilename:(NSString *)fn;

@end
