//
//  UIViewController+CustomModal.m
//  CustomSplitView
//
//  Created by Nobutaka on 2015/01/12.
//  Copyright (c) 2015年 test.org. All rights reserved.
//

#import "ModalViewControllerManager.h"
#import "UIViewController+CustomModal.h"

@implementation UIViewController (CustomModal)


- (void)presentCustomModalViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    
    [[ModalViewControllerManager sharedInstance] presentCustomModalViewController:viewController animated:animated completion:completion];
    
   
}

- (void)dismissCustomModalViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
    
    [[ModalViewControllerManager sharedInstance] dismissCustomModalViewAnimated:animated completion:completion];
    
}


@end
