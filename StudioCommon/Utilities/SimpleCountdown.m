//
//  SimpleCountdown.m
//  QQing
//
//  Created by 李杰 on 2/8/15.
//
//

#import "SimpleCountdown.h"

@interface SimpleCountdown ()

@property (nonatomic, strong) NSTimer *timer;
@property NSInteger counter;
@property NSInteger wattingCounter;
- (void)countingDown:(NSTimer *)timer;

@end

@implementation SimpleCountdown
@synthesize delegate = _delegate;
@synthesize timer;
@synthesize counter;

/*
 * 倒计时类
 *
 * @param total     秒
 */
- (id)initWithTimeout:(NSInteger)total {
    if (self = [self init]) {
        self.counter = total;
        if (total > 0) {
            self.countdown = YES;
            // Notice: scheduledTimerWithTimeInterval adds the timer to the current thread's run loop
            timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(countingDown:)
                                                   userInfo:nil
                                                    repeats:YES];
            
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            return self;
        }
    }
    
    return self;
}

- (id)initWithTimeout:(NSInteger)total autoStart:(BOOL)autoStart {
    if (self = [self init]) {
        self.counter = total;
        if (total > 0 && autoStart) {
            self.countdown = YES;
            timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(countingDown:)
                                                   userInfo:nil
                                                    repeats:YES];
            
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            return self;
        }
    }
    
    return self;
}

//添加等待的秒数
- (id)initTimer {
    if (self = [self init]) {
        self.countdown = NO;
        timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(countingUp:)
                                               userInfo:nil
                                                repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)initTimerDown {
    {
        self.countdown = YES;
        timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(countingDown:)
                                               userInfo:nil
                                                repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark 向上增
- (void)countingUp:(NSTimer *)timer{
    self.wattingCounter ++;
    if (self.delegate) {
        BOOL keepAlive = [self.delegate simpleCounter:self didCountingAt:self.wattingCounter];
        if (!keepAlive) {
            [self.timer invalidate];
            self.timer = nil;
            self.delegate = nil;
        }
    }
}

- (void)start {
    if (![self isCounting]) {
        // 如果没有开始，则开始
        if (self.countdown) {
            [self initTimerDown];
        } else {
            (void)[self initTimer];
        }
    }
}

- (void)cancel {
    [self.timer setFireDate:[NSDate distantFuture]];
    self.delegate = nil;
    
    [self.timer invalidate];
    self.timer = nil;
}

- (BOOL)isCounting {
    return self.timer ? YES : NO;
}

- (void)dealloc {
    if (self.timer) {
        [self cancel];
    }
}

#pragma mark -

- (void)countingDown:(NSTimer *)timer {
    self.counter --;
    
    if (self.delegate && self.counter >= 0) {
        BOOL keepAlive = NO;
        keepAlive = [self.delegate simpleCounter:self didCountingAt:self.counter];
        if (!keepAlive) {
            [self.timer invalidate];
            self.timer = nil;
            self.delegate = nil;
        }
    }
    
    if (self.counter == 0) {
        [self.timer invalidate];
        self.timer = nil;
        
        self.delegate = nil;
    }
    
    
}
@end
