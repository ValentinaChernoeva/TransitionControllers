//
//  NavigationDelegate.m
//  TransitionControllers
//
//  Created by Valentina Chernoeva on 05.04.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//

#import "NavigationDelegate.h"
#import "Animator.h"
#import "PanGestureInteractiveTransition.h"

@interface NavigationDelegate ()

@property (strong, nonatomic) PanGestureInteractiveTransition *interactiveTransition;
@property (assign, nonatomic) BOOL isInteractive;
@property (weak, nonatomic) UIViewController <TransitionProtocol> *transitionViewController;
@property (weak, nonatomic) UIViewController *toVC;

@end

@implementation NavigationDelegate

- (instancetype)initWithViewController:(UIViewController <TransitionProtocol>*)viewController {
    self = [super init];
    if (self) {
        self.transitionViewController = viewController;
    }
    return self;
}

- (void)setTransitionViewController:(UIViewController<TransitionProtocol> *)transitionViewController {
    _transitionViewController = transitionViewController;
    __weak typeof(self) wSelf = self;
    self.interactiveTransition = [[PanGestureInteractiveTransition alloc] initWithGestureRecognizerInView:transitionViewController.transitionBottomView recognizedBlock:^(UIPanGestureRecognizer *recognizer) {
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        if (velocity.y > 0.f) {
            wSelf.isInteractive = YES;
            [wSelf.transitionViewController.navigationController pushViewController:wSelf.transitionViewController.destanationViewController animated:YES];
        }
    }];
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPop) {
        self.isInteractive = NO;
        if ([fromVC isKindOfClass:[self.transitionViewController class]]) {
            return nil;
        }
    }
    Animator *animator = [[Animator alloc] init];
    animator.transitionTopView = self.transitionViewController.transitionTopView;
    animator.transitionBottomView = self.transitionViewController.transitionBottomView;
    animator.operation = operation;
    
    return animator;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.isInteractive ? self.interactiveTransition : nil;
}

@end
