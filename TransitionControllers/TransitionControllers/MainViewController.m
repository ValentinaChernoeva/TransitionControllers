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
    
    __weak typeof(self) wSelf = self;
    self.interactiveTransition = [[PanGestureInteractiveTransition alloc] initWithGestureRecognizerInView:self.transitionView recognizedBlock:^(UIPanGestureRecognizer *recognizer) {
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        if (velocity.y > 0.f) {
            wSelf.isInteractive = YES;
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
    self.isInteractive = NO;
    ImageViewController *vc = [ImageViewController instantiateFromMainStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    Animator *animator = [[Animator alloc] init];
    animator.transitionImageView = self.transitionImageView;
    animator.transitionView = self.transitionView;
    animator.operation = operation;
    
    if (operation == UINavigationControllerOperationPop) {
        self.isInteractive = NO;
        if ([fromVC isKindOfClass:[self class]]) {
           return nil;
        }
    }
    return animator;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.isInteractive ? self.interactiveTransition : nil;
}




@end
