//
//  ArchiveRecord.m
//  QQing
//
//  Created by 王涛 on 16/1/16.
//
//

#import "ArchiveRecord.h"

@implementation ArchiveRecord

+ (void)saveObject:(id)codeable asFilename:(NSString *)fn {
    if (fn &&
        [fn length] &&
        codeable) {
        
#ifdef DEBUG
        NSString *path = PATH_OF_DOCUMENT;
#else
        NSString *path = PATH_OF_CACHE;
#endif
        path = [NSString stringWithFormat:@"%@/%@", path, fn];
        
        NSLog(@"path = %@", path);
        
        [NSKeyedArchiver archiveRootObject:codeable toFile:path];
    }
}

+ (id)fetchWithFilename:(NSString *)fn {
    if (fn &&
        [fn length]) {
        
#ifdef DEBUG
        NSString *path = PATH_OF_DOCUMENT;
#else
        NSString *path = PATH_OF_CACHE;
#endif
        path = [NSString stringWithFormat:@"%@/%@", path, fn];
        
        NSLog(@"path = %@", path);
        
        return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
    return nil;
}

+ (void)deleteWithFilename:(NSString *)fn {
    NSFileManager *fileManager = [NSFileManager defaultManager];
#ifdef DEBUG
    NSString *path = PATH_OF_DOCUMENT;
#else
    NSString *path = PATH_OF_CACHE;
#endif
    path = [NSString stringWithFormat:@"%@/%@", path, fn];
    NSError *error;
    if ([fileManager removeItemAtPath:path error:&error] != YES) {
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    }
}

@end
