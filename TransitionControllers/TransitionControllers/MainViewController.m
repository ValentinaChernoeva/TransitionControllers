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
#import "PanGestureInteractiveTransition.h"
#import "UIViewController+Storyboard.h"

@interface MainViewController () <UINavigationControllerDelegate>

@property (strong, nonatomic) PanGestureInteractiveTransition *interactiveTransition;
@property (strong, nonatomic) Animator *animator;
@property (assign, nonatomic) BOOL isInteractive;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactiveTransition = [[PanGestureInteractiveTransition alloc] initWithGestureRecognizerInViewController:self recognizedBlock:^(UIPanGestureRecognizer *recognizer) {
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        if (velocity.y > 0.f) {
            ImageViewController *vc = [ImageViewController instantiateFromMainStoryboard];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

#pragma mark - Accessor methods

- (Animator *)animator {
    if (_animator == nil) {
        _animator = [[Animator alloc] init];
    }
    return _animator;
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
    
    if (operation == UINavigationControllerOperationPop) {
        self.isInteractive = NO;
        if ([fromVC isKindOfClass:[self class]]) {
           return nil;
        }
    } else {
        self.isInteractive = YES;
    }
    return self.animator;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.isInteractive ? self.interactiveTransition : nil;
}




@end
