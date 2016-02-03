//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import <objc/runtime.h>

#import "NSArray+Extension.h"
#import "NSObject+Extension.h"
#import "NSString+Extension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Property)

+ (const char *)attributesForProperty:(NSString *)property
{
	Class baseClass = [self baseClass];
	
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}

	for ( Class clazzType = self; clazzType != baseClass; )
	{
		objc_property_t prop = class_getProperty( clazzType, [property UTF8String] );
		if ( prop )
		{
			return property_getAttributes( prop );
		}
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}

	return NULL;
}

- (const char *)attributesForProperty:(NSString *)property
{
	return [[self class] attributesForProperty:property];
}

+ (NSDictionary *)extentionForProperty:(NSString *)property
{
	SEL fieldSelector = NSSelectorFromString( [NSString stringWithFormat:@"property_%@", property] );
	if ( [self respondsToSelector:fieldSelector] )
	{
		__autoreleasing NSString * field = nil;

		NSMethodSignature * signature = [self methodSignatureForSelector:fieldSelector];
		NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
		
		[invocation setTarget:self];
		[invocation setSelector:fieldSelector];
		[invocation invoke];
		[invocation getReturnValue:&field];

//		field = [self performSelector:fieldSelector];

		if ( field && [field length] )
		{
			NSMutableDictionary * dict = [NSMutableDictionary dictionary];
			
			NSArray * attributes = [field componentsSeparatedByString:@"____"];
			for ( NSString * attrGroup in attributes )
			{
				NSArray *	groupComponents = [attrGroup componentsSeparatedByString:@"=>"];
				NSString *	groupName = [[[groupComponents safeObjectAtIndex:0] trim] unwrap];
				NSString *	groupValue = [[[groupComponents safeObjectAtIndex:1] trim] unwrap];

				if ( groupName && groupValue )
				{
					[dict setObject:groupValue forKey:groupName];
				}
			}
			
			return dict;
		}
	}
	
	return nil;
}

- (NSDictionary *)extentionForProperty:(NSString *)property
{
	return [[self class] extentionForProperty:property];
}

+ (NSString *)extentionForProperty:(NSString *)property stringValueWithKey:(NSString *)key
{
	NSDictionary * extension = [self extentionForProperty:property];
	if ( nil == extension )
		return nil;
	
	return [extension objectForKey:key];
}

- (NSString *)extentionForProperty:(NSString *)property stringValueWithKey:(NSString *)key
{
	return [[self class] extentionForProperty:property stringValueWithKey:key];
}

+ (NSArray *)extentionForProperty:(NSString *)property arrayValueWithKey:(NSString *)key
{
	NSDictionary * extension = [self extentionForProperty:property];
	if ( nil == extension )
		return nil;
	
	NSString * value = [extension objectForKey:key];
	if ( nil == value )
		return nil;
	
	return [value componentsSeparatedByString:@"|"];
}

- (NSArray *)extentionForProperty:(NSString *)property arrayValueWithKey:(NSString *)key
{
	return [[self class] extentionForProperty:property arrayValueWithKey:key];
}

- (id)getAssociatedObjectForKey:(const char *)key
{
	const char * propName = key; // [[NSString stringWithFormat:@"%@.%s", NSStringFromClass([self class]), key] UTF8String];
	
	id currValue = objc_getAssociatedObject( self, propName );
	return currValue;
}

- (id)copyAssociatedObject:(id)obj forKey:(const char *)key
{
	const char * propName = key; // [[NSString stringWithFormat:@"%@.%s", NSStringFromClass([self class]), key] UTF8String];
	
	id oldValue = objc_getAssociatedObject( self, propName );
	objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_COPY );
	return oldValue;
}

- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;
{
	const char * propName = key; // [[NSString stringWithFormat:@"%@.%s", NSStringFromClass([self class]), key] UTF8String];
	
	id oldValue = objc_getAssociatedObject( self, propName );
	objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
	return oldValue;
}

- (id)assignAssociatedObject:(id)obj forKey:(const char *)key
{
	const char * propName = key; // [[NSString stringWithFormat:@"%@.%s", NSStringFromClass([self class]), key] UTF8String];
	
	id oldValue = objc_getAssociatedObject( self, propName );
	objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_ASSIGN );
	return oldValue;
}

- (void)removeAssociatedObjectForKey:(const char *)key
{
	const char * propName = key; // [[NSString stringWithFormat:@"%@.%s", NSStringFromClass([self class]), key] UTF8String];

	objc_setAssociatedObject( self, propName, nil, OBJC_ASSOCIATION_ASSIGN );
}

- (void)removeAllAssociatedObjects
{
	objc_removeAssociatedObjects( self );
}

#pragma mark - Make instance

+ (instancetype)instance {    
    return [[self alloc] init];
}

#pragma mark - Object 2 Json\Dictionary

- (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0; i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        
        return dic;
    }
    
    return [self getObjectData:obj];
}

- (NSDictionary*)getObjectData:(NSObject *)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for(int i = 0; i < propsCount; i++) {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil) {
            value = [NSNull null];
        } else {
            value = [self getObjectInternal:value];
            
        }
        
        [dic setObject:value forKey:propName];
    }
    
    return dic;
}

- (NSDictionary *)toDictionary
{
    return [self getObjectData:self];
}

- (NSData *)toJsonDataWithOptions:(NSJSONWritingOptions)options
{
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:self] options:options error:nil];
}

@end

