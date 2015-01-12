//
//  RootViewController.m
//  CustomSplitView
//
//  Created by Nobutaka on 2015/01/10.
//  Copyright (c) 2015年 test.org. All rights reserved.
//

#import "ModalViewControllerManager.h"
#import "Notification.h"
#import "RootViewController.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightPaneLeadingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftPaneWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftPaneLeading;
@property (assign, nonatomic) BOOL animating;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _animating = NO;
    
    [self addNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!_animating && ![ModalViewControllerManager sharedInstance].visible) {
        [self configureLayout];
    }
    
    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[ModalViewControllerManager sharedInstance] setModalView];
}

- (void)configureLayout {
    
    if ([self isPortrait]) {
        [self leftPaneClosedPortraitConstraint];
    } else {
        [self landscapeConstraint];
    }
    
}

- (void)leftPaneOpenPortraitConstraint {
    _rightPaneLeadingSpace.constant = 0;
    _leftPaneLeading.constant = 0;
}

- (void)leftPaneClosedPortraitConstraint {
    _rightPaneLeadingSpace.constant = 0;
    _leftPaneLeading.constant = -_leftPaneWidth.constant;
}

- (void)landscapeConstraint {
    _rightPaneLeadingSpace.constant = _leftPaneWidth.constant;
    _leftPaneLeading.constant = 0;
}

// TODO: Category
- (BOOL)isPortrait {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        return UIInterfaceOrientationIsPortrait(self.interfaceOrientation);
    } else {
        CGRect frame = self.view.window.frame;
        return frame.size.width <= frame.size.height ? YES : NO;
    }
    
}

- (void)addNotification {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(leftPaneChangeActionNotification:) name:LEFT_PANE_CHANGE_ACTION object:nil];
}

- (void)leftPaneChangeActionNotification:(NSNotification *)notification {
    
    if (![self isPortrait]) return;
    
    if (_leftPaneLeading.constant < 0) {
        [self leftPaneOpenPortraitConstraint];
    } else {
        [self leftPaneClosedPortraitConstraint];
    }
    
    _animating = YES;
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _animating = NO;
    }];
    
}

// MARK: Orientationの制御
// For under iOS 7
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [self leftPaneClosedPortraitConstraint];
    } else {
        [self landscapeConstraint];
    }
    
    [self.view layoutIfNeeded];
}

// For above iOS 8
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    if (size.width <= size.height) {
        [self leftPaneClosedPortraitConstraint];
    } else {
        [self landscapeConstraint];
    }
    
    [self.view layoutIfNeeded];
}

@end
