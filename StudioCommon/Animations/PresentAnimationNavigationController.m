//
//  PresentAnimationNavigationController.m
//  StudioCommon
//
//  Created by Ben on 15/8/26.
//  Copyright (c) 2015年 StudioCommon. All rights reserved.
//

#import "PresentAnimationNavigationController.h"
#import "PresentTransitioningDelegate.h"

@interface PresentAnimationNavigationController ()

@property (nonatomic, strong) PresentTransitioningDelegate *presentTransitioningDelegate;

@end

@implementation PresentAnimationNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.presentTransitioningDelegate = [PresentTransitioningDelegate new];
        self.transitioningDelegate = self.presentTransitioningDelegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
