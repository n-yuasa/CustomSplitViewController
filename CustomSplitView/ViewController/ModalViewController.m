//
//  ModalViewController.m
//  CustomSplitView
//
//  Created by Nobutaka on 2015/01/12.
//  Copyright (c) 2015年 test.org. All rights reserved.
//

#import "ModalViewController.h"
#import "UIViewController+CustomModal.h"

@interface ModalViewController ()

@end

@implementation ModalViewController


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setViewSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ModalViewController");
}

- (void)setViewSize {
    self.preferredContentSize = CGSizeMake(440, 600);
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)close:(id)sender {
    [self dismissCustomModalViewAnimated:NO completion:nil];
}

@end
