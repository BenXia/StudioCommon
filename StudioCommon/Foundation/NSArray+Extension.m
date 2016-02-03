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

#import "NSArray+Extension.h"
#import "NSObject+Extension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSArray(Extension)

- (NSArray *)head:(NSUInteger)count
{
	if ( 0 == self.count || 0 == count )
	{
		return nil;
	}
	
	if ( self.count < count )
	{
		return self;
	}

	NSRange range;
	range.location = 0;
	range.length = count;

	return [self subarrayWithRange:range];
}

- (NSArray *)tail:(NSUInteger)count
{	
	if ( 0 == self.count || 0 == count )
	{
		return nil;
	}
	
	if ( self.count < count )
	{
		return self;
	}

	NSRange range;
	range.location = self.count - count;
	range.length = count;

	return [self subarrayWithRange:range];
}

- (NSString *)join
{
	return [self join:nil];
}

- (NSString *)join:(NSString *)delimiter
{
	if ( 0 == self.count )
	{
		return @"";
	}
	else if ( 1 == self.count )
	{
		return [[self objectAtIndex:0] description];
	}
	else
	{
		NSMutableString * result = [NSMutableString string];
		
		for ( NSUInteger i = 0; i < self.count; ++i )
		{
			[result appendString:[[self objectAtIndex:i] description]];
			
			if ( delimiter )
			{
				if ( i + 1 < self.count )
				{
					[result appendString:delimiter];
				}
			}
		}
		
		return result;
	}
}

#pragma mark -

- (id)safeObjectAtIndex:(NSUInteger)index
{
	if ( index >= self.count )
		return nil;

	return [self objectAtIndex:index];
}

- (id)safeSubarrayWithRange:(NSRange)range
{
	if ( 0 == self.count )
		return [NSArray array];

	if ( range.location >= self.count )
		return [NSArray array];

	range.length = MIN( range.length, self.count - range.location );
	if ( 0 == range.length )
		return [NSArray array];
	
	return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (id)safeSubarrayFromIndex:(NSUInteger)index
{
	if ( 0 == self.count )
		return [NSArray array];
	
	if ( index >= self.count )
		return [NSArray array];
	
	return [self safeSubarrayWithRange:NSMakeRange(index, self.count - index)];
}

- (id)safeSubarrayWithCount:(NSUInteger)count
{
	if ( 0 == self.count )
		return [NSArray array];
	
	return [self safeSubarrayWithRange:NSMakeRange(0, count)];
}

@end

