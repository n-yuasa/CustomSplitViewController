//
//  ModalViewControllerManager.h
//  CustomSplitView
//
//  Created by Nobutaka on 2015/01/12.
//  Copyright (c) 2015年 test.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalViewControllerManager : UIViewController

@property (nonatomic, assign) BOOL visible;

+ (instancetype)sharedInstance;

- (void)setModalView;

- (void)presentCustomModalViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)dismissCustomModalViewAnimated:(BOOL)animated completion:(void (^)(void))completion;


@end
