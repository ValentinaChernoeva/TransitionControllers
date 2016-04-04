//
//  MainViewController.m
//  TransitionControllers
//
//  Created by Valentina Chernoeva on 04.04.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//

#import "MainViewController.h"
#import "Animator.h"
#import "ImageViewController.h"
#import "UIViewController+Storyboard.h"

@interface MainViewController () <UINavigationControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}


#pragma mark - Actions

- (IBAction)onImageTap:(UITapGestureRecognizer *)sender {
    ImageViewController *vc = [ImageViewController instantiateFromMainStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPop && [fromVC isKindOfClass:[self class]]) {
        return nil;
    } else {
        return [[Animator alloc] init];
    }

}

@end
