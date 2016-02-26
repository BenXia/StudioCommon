//
//  SimpleCountdown.h
//  QQing
//
//  Created by 李杰 on 2/8/15.
//
//

/**
 
 这里也可以是一个单利，用访问者，每一秒，它去访问一下，观察对象。如果没有观察者则，关闭timer。
 
 不然new 那么多倒计时对象，并不好看.
 
 */

#import <Foundation/Foundation.h>

@protocol SimpleCountdownDelegate;

@interface SimpleCountdown : NSObject {
    __weak id<SimpleCountdownDelegate> _delegate;
}

@property (nonatomic, weak) id <SimpleCountdownDelegate> delegate;

/**
 *  计时、倒计时
 
 *  @default 倒计时
 */
@property (nonatomic, assign) BOOL countdown;

- (id)initWithTimeout:(NSInteger)total;
- (id)initWithTimeout:(NSInteger)total autoStart:(BOOL)autoStart;
- (id)initTimer; // 累计，上数\并启动
- (void)initTimerDown;

- (void)start;
- (void)cancel;

- (BOOL)isCounting;

@end

@protocol SimpleCountdownDelegate <NSObject>

/**
 *  倒计时 计时回调
 *  @return  返回NO，则停止倒计时
 *  @param   count   当前计数值
 *  @param  counter  用于区别不同的计时器
 */
- (BOOL)simpleCounter:(SimpleCountdown *)counter didCountingAt:(NSInteger)count;

@end