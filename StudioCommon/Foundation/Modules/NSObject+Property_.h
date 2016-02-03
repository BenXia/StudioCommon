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

#import <Foundation/Foundation.h>

#pragma mark -

#undef	static_property
#define static_property( __name ) \
		property (nonatomic, readonly) NSString * __name; \
		- (NSString *)__name; \
		+ (NSString *)__name;

#undef	def_static_property
#define def_static_property( __name, ... ) \
		macro_concat(def_static_property, macro_count(__VA_ARGS__))(__name, __VA_ARGS__)

#undef	def_static_property0
#define def_static_property0( __name ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%s", #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%s", #__name]; }

#undef	def_static_property1
#define def_static_property1( __name, A ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", A, #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", A, #__name]; }

#undef	def_static_property2
#define def_static_property2( __name, A, B ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", A, B, #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", A, B, #__name]; }

#undef	def_static_property3
#define def_static_property3( __name, A, B, C ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%@.%s", A, B, C, #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%@.%s", A, B, C, #__name]; }

#undef	alias_static_property
#define alias_static_property( __name, __alias ) \
		dynamic __name; \
		- (NSString *)__name { return __alias; } \
		+ (NSString *)__name { return __alias; }

#pragma mark -

#undef	integer
#define integer( __name ) \
		property (nonatomic, readonly) NSInteger __name; \
		- (NSInteger)__name; \
		+ (NSInteger)__name;

#undef	def_integer
#define def_integer( __name, __value ) \
		dynamic __name; \
		- (NSInteger)__name { return __value; } \
		+ (NSInteger)__name { return __value; }

#pragma mark -

#undef	unsigned_integer
#define unsigned_integer( __name ) \
		property (nonatomic, readonly) NSUInteger __name; \
		- (NSUInteger)__name; \
		+ (NSUInteger)__name;

#undef	def_unsigned_integer
#define def_unsigned_integer( __name, __value ) \
		dynamic __name; \
		- (NSUInteger)__name { return __value; } \
		+ (NSUInteger)__name { return __value; }

#pragma mark -

#undef	number
#define number( __name ) \
		property (nonatomic, readonly) NSNumber * __name; \
		- (NSNumber *)__name; \
		+ (NSNumber *)__name;

#undef	def_number
#define def_number( __name, __value ) \
		dynamic __name; \
		- (NSNumber *)__name { return @(__value); } \
		+ (NSNumber *)__name { return @(__value); }

#pragma mark -

//#undef	string
//#define string( __name ) \
//		property (nonatomic, readonly) NSString * __name; \
//		- (NSString *)__name; \
//		+ (NSString *)__name;

#undef	STRING
#define STRING( __name ) \
property (nonatomic, readonly) NSString * __name; \
- (NSString *)__name; \
+ (NSString *)__name;

#undef	def_string
#define def_string( __name, __value ) \
		dynamic __name; \
		- (NSString *)__name { return __value; } \
		+ (NSString *)__name { return __value; }

#pragma mark -

#if __has_feature(objc_arc)

#define	prop_readonly( type, name )		property (nonatomic, readonly) type name;
#define	prop_dynamic( type, name )		property (nonatomic, strong) type name;
#define	prop_assign( type, name )		property (nonatomic, assign) type name;
#define	prop_strong( type, name )		property (nonatomic, strong) type name;
#define	prop_weak( type, name )			property (nonatomic, weak) type name;
#define	prop_copy( type, name )			property (nonatomic, copy) type name;
#define	prop_unsafe( type, name )		property (nonatomic, unsafe_unretained) type name;

#else

#define	prop_readonly( type, name )		property (nonatomic, readonly) type name;
#define	prop_dynamic( type, name )		property (nonatomic, retain) type name;
#define	prop_assign( type, name )		property (nonatomic, assign) type name;
#define	prop_strong( type, name )		property (nonatomic, retain) type name;
#define	prop_weak( type, name )			property (nonatomic, assign) type name;
#define	prop_copy( type, name )			property (nonatomic, copy) type name;
#define	prop_unsafe( type, name )		property (nonatomic, assign) type name;

#endif

#define prop_retype( type, name )		property type name;

#pragma mark -

#define def_prop_readonly( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_assign( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_strong( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_weak( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_unsafe( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_copy( type, name, ... ) \
		synthesize name = _##name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic( type, name, ... ) \
		dynamic name; \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic_copy( type, name, setName, ... ) \
		def_prop_custom( type, name, setName, copy ) \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic_strong( type, name, setName, ... ) \
		def_prop_custom( type, name, setName, retain ) \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic_unsafe( type, name, setName, ... ) \
		def_prop_custom( type, name, setName, assign ) \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic_weak( type, name, setName, ... ) \
		def_prop_custom( type, name, setName, assign ) \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_dynamic_pod( type, name, setName, pod_type ... ) \
		dynamic name; \
		- (type)name { return (type)[[self getAssociatedObjectForKey:#name] pod_type##Value]; } \
		- (void)setName:(type)obj { [self assignAssociatedObject:@((pod_type)obj) forKey:#name]; } \
		+ (NSString *)property_##name { return macro_string( macro_join(__VA_ARGS__) ); }

#define def_prop_custom( type, name, setName, attr ) \
		dynamic name; \
		- (type)name { return [self getAssociatedObjectForKey:#name]; } \
		- (void)setName:(type)obj { [self attr##AssociatedObject:obj forKey:#name]; }

#pragma mark - 

// Tag定义
#undef dec_tag // 声明
#define dec_tag( __name )       static_property( __name )

#undef  def_tag // 定义
#define def_tag( __name )       def_static_property2( __name, @"tag", [self description] )

#undef  tag_equal
#define tag_equal( __tag1, __tag2 ) ([__tag1 isEqualToString:__tag2])

#undef  tag_string_for
#define tag_string_for( __value ) [NSString stringWithFormat:@"tag.%d", __value]


#pragma mark -

// NSObject has +instance method
// 实例属性，而非类方法
#undef  prop_instance
#define prop_instance( __type, __name ) \
property (nonatomic, strong) __type * __name;

#undef  def_prop_instance
#define def_prop_instance( __type, __name ) \
synthesize __name; \
- (__type *)__name { \
/* _##__name */if (!__name) { \
__name = [__type instance]; \
} \
\
return __name; \
}

// event

#undef  EVENT_EQUAL
#define EVENT_EQUAL( __tag1, __tag2 ) ([(NSString *)__tag1 isEqualToString:(NSString *)__tag2])

// class

#undef  CLASS_EUQAL
#define CLASS_EUQAL(inst, target_class_type) [inst isKindOfClass:[target_class_type class]]

#undef  CLASSNAME
#define CLASSNAME(inst) NSStringFromClass([inst class])

#undef  CLASS
#define CLASS(classname) NSClassFromString(classname)

// Service定义
#undef	DEC_INSTANCE_PROPERTY_STRONG
#define DEC_INSTANCE_PROPERTY_STRONG( __type, __name ) \
@property (nonatomic, strong) __type * __name;

#undef	DEC_INSTANCE_PROPERTY_WEAK
#define DEC_INSTANCE_PROPERTY_WEAK( __type, __name ) \
@property (nonatomic, weak) __type * __name;

#undef  DEF_INSTANCE_PROPERTY
#define DEF_INSTANCE_PROPERTY( __type, __name ) \
- (__type *)__name { \
if (!_##__name) { \
_##__name = [__type instance]; \
} \
\
return _##__name; \
}

#undef  DEC_INSTANCE_PROPERTY
#define DEC_INSTANCE_PROPERTY DEC_INSTANCE_PROPERTY_STRONG // default: strong

#undef  DEC_SERVICE_PROPERTY
#define DEC_SERVICE_PROPERTY DEC_INSTANCE_PROPERTY_WEAK

#undef  DEF_SERVICE_PROPERTY
#define DEF_SERVICE_PROPERTY DEF_INSTANCE_PROPERTY

#pragma mark -

@interface NSObject(Property)

+ (const char *)attributesForProperty:(NSString *)property;
- (const char *)attributesForProperty:(NSString *)property;

+ (NSDictionary *)extentionForProperty:(NSString *)property;
- (NSDictionary *)extentionForProperty:(NSString *)property;

+ (NSString *)extentionForProperty:(NSString *)property stringValueWithKey:(NSString *)key;
- (NSString *)extentionForProperty:(NSString *)property stringValueWithKey:(NSString *)key;

+ (NSArray *)extentionForProperty:(NSString *)property arrayValueWithKey:(NSString *)key;
- (NSArray *)extentionForProperty:(NSString *)property arrayValueWithKey:(NSString *)key;

- (id)getAssociatedObjectForKey:(const char *)key;
- (id)copyAssociatedObject:(id)obj forKey:(const char *)key;
- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;
- (id)assignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)removeAssociatedObjectForKey:(const char *)key;
- (void)removeAllAssociatedObjects;

#pragma mark - Make instance once

+ (instancetype)instance;

#pragma mark - Object 2 Json\Dictionary

- (NSDictionary *)toDictionary; // 打印属性名－属性值的，键值对

- (NSData *)toJsonDataWithOptions:(NSJSONWritingOptions)options;

@end
