//
//  BaseViewController.m
//  Dentist
//
//  Created by Ben on 10/15/15.
//  Copyright © 2016年 iOSStudio. All rights reserved.
//

#import "BaseViewController.h"
#import "Masonry.h"
#import "LoadingView.h"

static const CGFloat kNavigationItemFontSize = 16.0f;

@interface BaseViewController ()

@property (strong,nonatomic) UIActivityIndicatorView *loadingIndicator;
@property (strong,nonatomic) LoadingView *loadingView;

//
@property (copy,nonatomic) UIColor* originNavBarColor;
@property (copy,nonatomic) UIColor* originNavTitleColor;
@property (assign,nonatomic) BOOL hasPreferNavBarColor;
@property (assign,nonatomic) BOOL hasPreferNavTitleColor;

@end

@implementation BaseViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIColor* preferNavBarColor = [self preferNavBarBackgroundColor];
    if (preferNavBarColor) {
        self.hasPreferNavBarColor = YES;
        self.originNavBarColor = self.navBarColor;
        self.navBarColor = preferNavBarColor;
    }
    
    UIColor* preferNavBarNormalTitleColor = [self preferNavBarNormalTitleColor];
    if (preferNavBarNormalTitleColor) {
        self.hasPreferNavTitleColor = YES;
        self.originNavTitleColor = self.navTitleColor;
        self.navTitleColor = preferNavBarNormalTitleColor;
        self.navLeftItemNormalTitleColor = preferNavBarNormalTitleColor;
        self.navRightItemNormalTitleColor = preferNavBarNormalTitleColor;
    }
    
    UIColor* preferNavItemHighlightedTitleColor = [self preferNavBarHighlightedTitleColor];
    if (preferNavItemHighlightedTitleColor) {
        self.navItemHighlightedTitleColor = preferNavItemHighlightedTitleColor;
    }
    
    [BaseConfiguration adapterAppDentist:^{
        NSString* preferNavBackTitle = [self preferNavBackButtonTitle];
        if (preferNavBackTitle.length > 0) {
            [self setNavBackButtonWithTitle:preferNavBackTitle];
        } else {
            if (self != [self.navigationController.viewControllers firstObject]) {
                [self setNavLeftItemWithImage:@"btn_back_white" target:self action:@selector(didClickOnBackButton)];
            }
        }
    } appTxtd:^{
        [self setNavBackButtonWithTitle:@"返回"];
    } appTemplateProject:^{
        [self setNavBackButtonWithTitle:@"返回"];
    }];
    
//    NSString* preferNavBackTitle = [self preferNavBackButtonTitle];
//    if (preferNavBackTitle.length > 0) {
        //[self setNavBackButtonWithTitle:preferNavBackTitle];
        [self setNavBackButtonWithTitle:@"返回"];
//    } else {
//        if (self != [self.navigationController.viewControllers firstObject]) {
//            [self setNavLeftItemWithImage:@"btn_back_white" target:self action:@selector(didClickOnBackButton)];
//        }
//    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //解决手势返回失效的问题
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else{
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.hasPreferNavBarColor) {
        if (self.originNavBarColor) {
            self.navBarColor = self.originNavBarColor;
        } else {
            self.navBarColor = [g_commonConfig themeBlueColor];
        }
    }
    
    if (self.hasPreferNavTitleColor) {
        self.navTitleColor = self.originNavTitleColor;
        self.navLeftItemNormalTitleColor = self.originNavBarColor;
        self.navRightItemNormalTitleColor = self.originNavBarColor;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel:(id)vm {
    // do nothing
}

- (void)didClickOnBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Play with view model: overrided if needed

- (instancetype)initWithViewModel:(id)viewModel {
    return [super init];
}

#pragma mark - Views operations

- (void)initializeViews {
    // Do nothing...
}

#pragma mark - Virtual methods

- (void)applyViewConstraints {
    // Do nothing...
}

- (void)updateVCviewsConstraints {
    
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

#pragma mark - NavigationBar style

- (UIColor *)preferNavBarBackgroundColor{
    return [g_commonConfig themeBlueColor];
}

- (UIColor *)preferNavBarNormalTitleColor{
    return [UIColor whiteColor];
}

- (UIColor *)preferNavBarHighlightedTitleColor {
    return [UIColor whiteColor];
}

- (NSString*)preferNavBackButtonTitle{
    if ([self.navigationController.viewControllers containsObject:self]) {
        NSInteger lastVCIndex = [self.navigationController.viewControllers indexOfObject:self] - 1;
        if (lastVCIndex >= 0) {
            UIViewController* lastVC = [self.navigationController.viewControllers objectAtIndex:lastVCIndex];
            return lastVC.title;
        }
    }
    
    return nil;
}

#pragma mark - Status style

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation

- (void)pushVC:(UIViewController *)vc animate:(BOOL)animate {
    [self.navigationController pushViewController:vc animated:animate];
}

- (void)pushVC:(UIViewController *)vc {
    [self pushVC:vc animate:YES];
}

- (void)popVCAnimate:(BOOL)animate {
    [self.navigationController popViewControllerAnimated:animate];
}

- (void)popVC {
    [self popVCAnimate:YES];
}

- (void)popToVC:(UIViewController *)vc animate:(BOOL)animate {
    [self.navigationController popToViewController:vc animated:animate];
}

- (void)popToVC:(UIViewController *)vc {
    [self popToVC:vc animate:YES];
}

- (void)popToRootAnimate:(BOOL)animate {
    [self.navigationController popToRootViewControllerAnimated:animate];
}

- (void)popToRoot {
    [self popToRootAnimate:YES];
}

#pragma mark - Utility

- (BOOL)isVisibleEx {
    return (self.isViewLoaded && self.view.window);
}

//显示系统自带的菊花
- (void)showLoadingIndicator{
    [self.loadingIndicator bringToFront];
    self.loadingIndicator.hidden = NO;
    [self.loadingIndicator startAnimating];
}

- (void)hideLoadingIndicator{
    [self.loadingIndicator stopAnimating];
    self.loadingIndicator.hidden = YES;
}

- (void)showLoadingView{
    [self.loadingView bringToFront];
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
}
- (void)hideLoadingView{
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}

-(void)setNavBackButtonWithTitle:(NSString*)title{
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [backButton setTitle:title forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:kNavigationItemFontSize];
    [backButton setTitleColor:[UIColor whiteColor]];
    [backButton setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    CGFloat imageWidth = backButton.imageView.size.width;
    CGFloat titleWidth = [backButton.titleLabel.text textSizeForOneLineWithFont:backButton.titleLabel.font].width;
    backButton.width = imageWidth + titleWidth;
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton addTarget:self action:@selector(didClickOnBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self setNavLeftItemWithButton:backButton];
}


#pragma mark - DataBinder

- (void)bindViewModel {
    QQLog(@"Warning: 该方法应该被覆盖！");
}

#pragma mark - Getter

-(UIActivityIndicatorView*)loadingIndicator{
    if (_loadingIndicator == nil) {
        _loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:_loadingIndicator];
        [_loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
    }
    return _loadingIndicator;
}

-(LoadingView*)loadingView{
    if (_loadingView == nil) {
        _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake((kScreenWidth - 60)/2, 60, 60, 60)];
        [self.view addSubview:_loadingView];
    }
    return _loadingView;
}

@end
