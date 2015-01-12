//
//  ModalViewControllerManager.m
//  CustomSplitView
//
//  Created by Nobutaka on 2015/01/12.
//  Copyright (c) 2015年 test.org. All rights reserved.
//

#import "AppDelegate.h"
#import "ModalViewControllerManager.h"


#define ANIMATION_DURATION 0.25f // view表示アニメーション 0.25秒で表示させる
#define MODALVIEW_BACKGOUND_COLOR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]

static NSString *const kVerticalVFL = @"V:|-(length)-[modalView]-(length)-|";

@interface ModalViewControllerManager ()

// 黒背景画面 この画面の上にモーダルに表示するViewController.viewをaddする
@property (nonatomic, strong) UIView *backView;

// モーダルに表示するUIViewController
@property (nonatomic, strong) UIViewController *viewController;

// V:[_backView]-(=Fixed_point)-[_viewController.view]-(=Fixed_point)-[_backView]
// を満たす制約
@property (nonatomic, strong) NSArray *verticalConstraints;

@end

@implementation ModalViewControllerManager

+ (instancetype)sharedInstance {
    
    static dispatch_once_t once;
    
    static ModalViewControllerManager *sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _visible = NO;
    }
    
    return self;
}

- (void)setModalView {
    if (!_backView) {
        [self createBackGroundView];
    }
}

- (void)createBackGroundView {
    _backView = UIView.new;
    // auto layoutを使用する
    _backView.translatesAutoresizingMaskIntoConstraints = NO;
    _backView.hidden = YES;
    // 背景色を黒に設定
    _backView.backgroundColor = MODALVIEW_BACKGOUND_COLOR;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootViewController = window.rootViewController;
    UIView *rootView = rootViewController.view;
    [rootView addSubview:_backView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_backView);
    
    // horizontal constraint
    NSString *horizontal = @"H:|[_backView]|";
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontal options:0 metrics:nil views:views]];
    
    // vertical constraint
    NSString *vertical = @"V:|[_backView]|";
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vertical options:0 metrics:nil views:views]];
    
    [rootView layoutIfNeeded];
}

- (void)presentCustomModalViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    
    _visible = YES;
   
    _viewController = viewController;
    _backView.hidden = NO;
    [_backView addSubview:_viewController.view];
    // 最前面に持ってくる
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window bringSubviewToFront:_backView];
    [self addConstraintsToView];
    
    // 表示アニメーションなし
    if (!animated) {
        [self perfomCompletion:completion];
        return;
    }
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [_backView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self perfomCompletion:completion];
    }];
 
}

- (void)dismissCustomModalViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
    
    _visible = NO;
    
    // 非表示アニメーションなし
    if (!animated) {
        [_viewController.view removeFromSuperview];
        _viewController = nil;
        [self perfomCompletion:completion];
        _backView.hidden = YES;
        return;
    }
    
    // 非表示アニメーションあり
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        [_backView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_viewController.view removeFromSuperview];
        _viewController = nil;
        [self perfomCompletion:completion];
       _backView.hidden = YES;
    }];
 
}

/**
 * 
 * @desc viewController.viewに制約をつける
 *
 */
- (void)addConstraintsToView {
    
    UIView *modalView = _viewController.view;
    modalView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(modalView, _backView);
    
    // 水平中央寄せ
    NSLayoutConstraint *horizontalCenter = [NSLayoutConstraint constraintWithItem:modalView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    // 横幅は_viewController.preferredContentsSize.widthを使用
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:modalView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:_viewController.preferredContentSize.width];
    
    _verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:kVerticalVFL options:0 metrics:@{@"length":@(40)} views:views];
    
    [_backView addConstraints:@[horizontalCenter, width]];
    [_backView addConstraints:_verticalConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)perfomCompletion:(void (^)(void))completion {
    if (completion) {
        completion();
    }
}

@end
