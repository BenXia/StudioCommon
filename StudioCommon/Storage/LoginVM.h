//
//  LoginVM.h
//  Dentist
//
//  Created by 王涛 on 16/1/16.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginVM : NSObject
- (void)LoginWithName:(NSString *)name PassWord:(NSString *)password compleHandle:(ObjectBlock)compleBlock errorHandle:(ObjectBlock)errorBlock;
- (void)autoLoginCompleHandle:(ObjectBlock)compleBlock errorHandle:(ObjectBlock)errorBlock;
@end
