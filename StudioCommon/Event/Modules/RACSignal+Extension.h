//
//  RACSignal+Extension.h
//  StudioCommon
//
//  Created by Ben on 2/3/16.
//  Copyright © 2016年 StudioCommon. All rights reserved.
//

#import "RACSignal.h"

@interface RACSignal (Extension)

- (RACSignal *)onMainThread;

@end
