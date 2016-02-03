//
//  Samurai_Error.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import <objc/runtime.h>
#import "NSError+Handler.h"

@implementation NSError (Handler)

@def_string( messagedKey, @"NSError.message.key" )

@def_string( CocoaErrorDomain           , NSCocoaErrorDomain )
@def_string( LocalizedDescriptionKey    , NSLocalizedDescriptionKey )
@def_string( StringEncodingErrorKey     , NSStringEncodingErrorKey )
@def_string( URLErrorKey                , NSURLErrorKey )
@def_string( FilePathErrorKey           , NSFilePathErrorKey )
@def_string( SamuraiErrorDomain         , @"NSError.samurai.domain" )

#pragma mark - Error maker

+ (instancetype)errorWithDomain:(NSString *)domain
                           code:(NSInteger)code
                           desc:(NSString *)desc { // desc 可以为空
    NSAssert(domain, @"Domain nil");
    
    desc = !desc ? @"" : desc;
    
    NSDictionary *userInfo      = @{[self messagedKey]:desc};
    NSError *error              = [self errorWithDomain:domain code:code userInfo:userInfo];;
    
    // 加入pool
    if (![error isPooled]) {
        [error toPool];
        
        return error;
    } else {
        return [error fromPool];
    }
}

#pragma mark - Equal

- (BOOL)isInteger:(NSInteger)code {
    return [self code] == code;
}

- (BOOL)is:(NSError *)error {
    
    if ([[self domain] isEqual:[error domain]] &&
        [self code] == [error code]) {
        return YES;
    } else if ([self code] == [error code]) {
        DDLogWarn(@"error 相比，code相等，domain不同, %@, %@", self, error);
        
        return YES;
    }
    
    return NO;
}

#pragma mark - UserInfo

- (NSString *)message {
    if (self.userInfo &&
        [self.userInfo.allKeys containsObject:[self messagedKey]]) {
        
        return self.userInfo[[self messagedKey]];
    }
    
    // 兼容配置版本处理
    if (self.userInfo &&
        [self.userInfo.allKeys containsObject:kUSERINFO_INPUT_INFO_KEY]) {
        if ([self.userInfo[kUSERINFO_INPUT_INFO_KEY] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *messageDict   = self.userInfo[kUSERINFO_INPUT_INFO_KEY];
            
            if ([messageDict.allValues count]) {
                if ([messageDict.allValues[0] isKindOfClass:[NSString class]]) {
                    return messageDict.allValues[0];
                }
            }
        } else if ([self.userInfo[kUSERINFO_INPUT_INFO_KEY] isKindOfClass:[NSString class]]) {
            return self.userInfo[kUSERINFO_INPUT_INFO_KEY];
        }
    }
    
    // 尝试兼容常规版本，默认取出userInfo中的一对键值
    if (self.userInfo &&
        [self.userInfo.allValues count]) {
        __block NSString *message   = UNDEFINED_STRING;
        
        [self.userInfo.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                message = obj;
                
                *stop   = YES;
            }
        }];
        
        return message;
    }
    
    // 没有消息
    return UNDEFINED_STRING;
}

- (NSError *)with:(NSDictionary *)userinfo {
    //    NSAssert(userinfo, @"nil");
    //
    //    NSMutableDictionary *togetherDict   = [self.userInfo mutableCopy];
    //
    //    [togetherDict addEntriesFromDictionary:userinfo];
    //
    //    _userInfo   = togetherDict;
    
    // todo：扩展了FAMutableError之后，可用。原地修改userInfo
    
    return self;
}

#pragma mark - Extern pool - 优先

// rentzsch/jrswizzle start

+ (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(self, origSel);
    
    if (!origMethod) {
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel), class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel {
    return [object_getClass(self) swizzleMethod:origSel withMethod:altSel];
}

// rentzsch/jrswizzle end

+ (void)setExternalErrorPool:(NSMutableDictionary *)pool {
    (void)([self externalPool:pool]);
}

+ (NSMutableDictionary *)externalPool:(NSMutableDictionary *)pool {
    static NSMutableDictionary *storedPool;
    
    if (pool) {
        NSAssert([pool isKindOfClass:[NSMutableDictionary class]], @"pool class imcompatable");
        
        storedPool                  = pool;
    }
    
    return storedPool;
}

+ (NSMutableDictionary *)externalPool {
    return [self externalPool:nil];
}

#pragma mark - Key

- (NSString *)storedKey {
    return [NSString stringWithFormat:@"%@.%zd", self.domain, self.code]; // todo: use MACRO
}

- (NSString *)domainKey {
    return [self domain];
}

- (NSNumber *)codeKey {
    return @(self.code);
}

#pragma mark - Error pool

+ (id)errorPoolOrCreate {
    static NSMutableDictionary *pool;
    
    if (!pool) {
        pool                        = [NSMutableDictionary new];
    }
    
    return pool;
}

+ (id)errorPool {
    return [self errorPoolOrCreate];
}

- (id)errorPoolOrCreate {
    return [self.class errorPoolOrCreate];
}

- (id)errorPool {
    return [self.class errorPool];
}

#pragma mark - Error manage

+ (BOOL)isPooled:(NSString *)key {
    NSAssert(key, @"Error key nil");
    
    return NO;
}

- (BOOL)isPooled {
    NSMutableDictionary *pool       = [self errorPool];
    
    if (!pool) {
        return NO;
    }
    
    if ([pool.allKeys containsObject:[self storedKey]]) {
        return YES;
    }
    
    return NO;
}

- (void)toPool {
    NSAssert(self.storedKey, @"Error key nil");
    
    // 加入到内部pool
    NSMutableDictionary *pool       = [self errorPool];
    
    if (pool && ![pool.allKeys containsObject:[self storedKey]]) {
        [pool setObject:self forKey:[self storedKey]];
    }
    
    // 加入到外部pool
    NSMutableDictionary *externalPool= [self.class externalPool];
    
    if (externalPool) {
        // 第一层为 domain 到 domain下的errorMessage字典
        NSMutableDictionary *messageDict = nil;
        id messagePool              = [externalPool objectForKey:[self domainKey]];
        
        if (!messagePool) {
            messageDict             = [@{} mutableCopy];
            
            [externalPool setObject:messageDict forKey:[self domainKey]];
        } else {
            messageDict             = messagePool;
        }
        
        // 第二层为 errorCode的NSNumber对象 到 errorMessage的NSString对象
        [messageDict setObject:[self message] forKey:[self codeKey]];
    }
}

- (NSDictionary *)pooling {
    return @{[self storedKey] : self};
}

// 从内部pool中取出来
- (id)fromPool {
    if ([self isPooled]) {
        NSMutableDictionary *pool       = [self errorPool];
        
        return [pool objectForKey:[self storedKey]];
    } else {
        return nil;
    }
}

// 不移除外部pool中的信息
- (void)removeFromPool {
    NSAssert(self.storedKey, @"Error key nil");
    
    NSMutableDictionary *pool       = [self errorPool];
    
    if (pool && [pool.allKeys containsObject:[self storedKey]]) {
        [pool removeObjectForKey:[self storedKey]];
    }
}

- (void)removeAllErrorsFromPool {
    NSMutableDictionary *pool       = [self errorPool];
    
    if (pool) {
        [pool removeAllObjects];
    }
}

@end

#pragma mark - NSObject (Property_Traversal)

@interface NSObject (Property_Traversal)

- (void)objectPropertyTraversal; // 也可以withBlock，对属性进行处理

+ (void)objectPropertyTraversal; // 也可以withBlock，对属性进行处理

@end

@implementation NSObject (Property_Traversal)

+ (void)objectPropertyTraversal {
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([self class], &propsCount);
    
//    TODO( "Should be 递归" )
    for(int i = 0; i < propsCount; i++) {
        objc_property_t prop    = props[i];
        NSString *propName      = [NSString stringWithUTF8String:property_getName(prop)];
        __unused id value       = [self valueForKey:propName];
    }
}

- (void)objectPropertyTraversal {
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([self class], &propsCount);
    
//    TODO( "Should be 递归" )
    
    for(int i = 0; i < propsCount; i++) {
        objc_property_t prop    = props[i];
        NSString *propName      = [NSString stringWithUTF8String:property_getName(prop)];
        __unused id value       = [self valueForKey:propName];
    }
}

@end

#pragma mark - NSObject (NSError_Handler)

@implementation NSObject (NSError_Handler)

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

+ (NSError *)errorForCode:(NSInteger)code {
    NSError *error = make_error(make_string_obj(NSStringFromClass([self class])), code);
    
    if (![error isPooled]) { // pool中没有该key的error
        [self objectPropertyTraversal];
    }
    
    return make_error_3(make_string_obj(NSStringFromClass([self class])), code, nil);
}

- (NSError *)errorForCode:(NSInteger)code {
    NSError *error = make_error(make_string_obj(NSStringFromClass([self class])), code);
    
    if (![error isPooled]) {
        [self objectPropertyTraversal];
    }
    
    return make_error_3(make_string_obj(NSStringFromClass([self class])), code, nil);
}

@end