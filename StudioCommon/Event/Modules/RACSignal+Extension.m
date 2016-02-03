//
//  RACSignal+Extension.m
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "RACSignal+Extension.h"
#import "ReactiveCocoa.h"

@implementation RACSignal (Extension)

- (RACSignal *)onMainThread {
    return [self deliverOn:RACScheduler.mainThreadScheduler];
}

@end
