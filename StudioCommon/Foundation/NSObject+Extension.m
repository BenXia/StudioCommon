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

#import "NSObject+Extension.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"


// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(Extension)

+ (Class)baseClass
{
	return [NSObject class];
}

+ (BOOL)isReadOnly:(const char *)attr
{
    if ( strstr(attr, "_ro") || strstr(attr, ",R") )
    {
        return YES;
    }
    
    return NO;
}

- (void)deepEqualsTo:(id)obj
{
	Class baseClass = [[self class] baseClass];
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}
	
	for ( Class clazzType = [self class]; clazzType != baseClass; )
	{
		unsigned int		propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			const char *	attr = property_getAttributes(properties[i]);
			
			if ( [self.class isReadOnly:attr] )
			{
				continue;
			}
			
			NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			NSObject * propertyValue = [(NSObject *)obj valueForKey:propertyName]; // kvc

			[self setValue:propertyValue forKey:propertyName];
		}
		
		free( properties );
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}
}

- (void)deepCopyFrom:(id)obj
{
	if ( nil == obj )
	{
		return;
	}
	
	Class baseClass = [[obj class] baseClass];
	if ( nil == baseClass )
	{
		baseClass = [NSObject class];
	}
	
	for ( Class clazzType = [obj class]; clazzType != baseClass; )
	{
		unsigned int		propertyCount = 0;
		objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
		
		for ( NSUInteger i = 0; i < propertyCount; i++ )
		{
			const char *	name = property_getName(properties[i]);
			const char *	attr = property_getAttributes(properties[i]);
			
			if ( [self.class isReadOnly:attr] )
			{
				continue;
			}
			
			NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
			NSObject * propertyValue = [(NSObject *)obj valueForKey:propertyName]; // kvc
			
			[self setValue:propertyValue forKey:propertyName];
		}
		
		free( properties );
		
		clazzType = class_getSuperclass( clazzType );
		if ( nil == clazzType )
			break;
	}
}

- (id)clone
{
	id newObject = [[[self class] alloc] init];

	if ( newObject )
	{
		[newObject deepCopyFrom:self];
	}

	return newObject;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if __SAMURAI_TESTING__

@interface __SimpleClass : NSObject
@prop_strong( NSNumber *,			number );
@prop_strong( NSString *,			string );
@prop_strong( NSDate *,				date );
@prop_strong( NSData *,				data );
@prop_strong( NSURL *,				url );
@end

@interface __ComplexClass : __SimpleClass
@prop_strong( NSArray *,			array1 );
@prop_strong( NSArray *,			array2 );
@prop_strong( NSArray *,			array3 );
@prop_strong( NSDictionary *,		dict );
@prop_strong( __SimpleClass *,		object1 );
@prop_strong( __ComplexClass *,		object2 );
@end

@implementation __SimpleClass
@def_prop_strong( NSNumber *,		number );
@def_prop_strong( NSString *,		string );
@def_prop_strong( NSDate *,			date );
@def_prop_strong( NSData *,			data );
@def_prop_strong( NSURL *,			url );
@end

@implementation __ComplexClass
@def_prop_strong( NSArray *,		array1 );
@def_prop_strong( NSArray *,		array2,		Class => __SimpleClass );
@def_prop_strong( NSArray *,		array3,		Class => __ComplexClass );
@def_prop_strong( NSDictionary *,	dict );
@def_prop_strong( __SimpleClass *,	object1 );
@def_prop_strong( __ComplexClass *,	object2 );

BASE_CLASS( NSObject )

//CONVERT_CLASS( array2, __SimpleClass )
//CONVERT_CLASS( array3, __ComplexClass )

@end

TEST_CASE( Core, NSObject_Extension )
{
	
}

DESCRIBE( before )
{
}

DESCRIBE( serialize )
{
	__SimpleClass * simple = [[__SimpleClass alloc] init];
	simple.number = @1;
	simple.string = @"2";
	simple.date = [NSDate date];
//	simple.data = [NSData dataWithBytes:"123456" length:6];
	simple.url = [NSURL URLWithString:@"http://www.geek-zoo.com"];
	
	__ComplexClass * complex = [[__ComplexClass alloc] init];
	__ComplexClass * complex2 = [[__ComplexClass alloc] init];
	
	complex2.number = @1;
	complex2.string = @"2";
	complex2.date = [NSDate date];
//	complex2.data = [NSData dataWithBytes:"123456" length:6];
	complex2.url = [NSURL URLWithString:@"http://www.geek-zoo.com"];

	complex.number = @1;
	complex.string = @"2";
	complex.date = [NSDate date];
//	complex.data = [NSData dataWithBytes:"123456" length:6];
	complex.url = [NSURL URLWithString:@"http://www.geek-zoo.com"];
	
	complex.array1 = @[simple.number, simple.string, simple.date, /*simple.data,*/ simple.url];
	complex.array2 = @[simple, simple];
	complex.array3 = @[complex2, complex2];
	complex.dict = @{@"k1":simple.number,
					 @"k2":simple.string,
					 @"k3":simple.date,
					 //					 @"k4":simple.data,
					 @"k5":simple.url,
					 @"k6":complex.array1,
					 @"k7":complex.array2,
					 @"k8":complex.array3,
					 @"k9":simple,
					 @"k10":complex2};
	complex.object1 = simple;
	complex.object2 = complex2;
		
	id obj1 = [simple serialize];
	id obj2 = [complex serialize];
	
	NSString * obj1JSON = [[obj1 JSONEncoded] toString];
	NSString * obj2JSON = [[obj2 JSONEncoded] toString];
	
	EXPECTED( obj1 )
	EXPECTED( obj2 )
	EXPECTED( obj1JSON )
	EXPECTED( obj2JSON )
}

DESCRIBE( after )
{
}

TEST_CASE_END

#endif	// #if __SAMURAI_TESTING__
