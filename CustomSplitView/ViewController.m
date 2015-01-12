//
//  ViewController.m
//  CustomSplitView
//
//  Created by Nobutaka on 2015/01/10.
//  Copyright (c) 2015年 test.org. All rights reserved.
//

#import "Notification.h"
#import "ViewController.h"
#import "UIViewController+CustomModal.h"


#define NAV_HEIGHT 64.0f

@interface ViewController () <UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// MARK: - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    _navBar.delegate = self;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        _navBar.frame = CGRectMake(0, 0, self.view.frame.size.width, NAV_HEIGHT);
    }
    
    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// MARK: - Button Action
- (IBAction)buttonAction:(id)sender {
    [self notifyChangeLeftPaneChange];
}

- (IBAction)modalButtonAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Modal" bundle:nil];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    [self presentCustomModalViewController:viewController animated:NO completion:nil];
}

- (void)notifyChangeLeftPaneChange {
    NSNotification *notification = [NSNotification notificationWithName:LEFT_PANE_CHANGE_ACTION object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

// MARK: - UIBarPositioningDelegate
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}



@end
