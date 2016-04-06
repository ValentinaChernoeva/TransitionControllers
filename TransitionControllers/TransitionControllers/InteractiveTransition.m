//
//  InteractiveTransition.m
//  TransitionControllers
//
//  Created by Valentina Chernoeva on 06.04.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//

#import "InteractiveTransition.h"
#import "Animator.h"
#import "Utilits.h"

@interface InteractiveTransition ()

@property (assign, nonatomic) BOOL isInteractive;

@end

@implementation InteractiveTransition

- (instancetype)initWithGestureRecognizerInView:(UIView *)view
                                       animator:(Animator *)animator
                                recognizedBlock:(InteractiveHandler)gestureRecognizedBlock {
    self = [super init];
    if (self) {
        self.gestureRecognizedBlock = gestureRecognizedBlock;
        self.animator = animator;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
        [view addGestureRecognizer:panGesture];
    }
    return self;
}

#pragma mark - Gestures

- (void)gestureHandler:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint location = [recognizer locationInView:recognizer.view];
    CGPoint tranlation = [recognizer translationInView:recognizer.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.isInteractive = YES;
        PERFORM_BLOCK_IF_NOT_NIL(self.gestureRecognizedBlock, recognizer);
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat d = tranlation.y / CGRectGetHeight(recognizer.view.bounds);
        if (d > 0) {
            [self updateInteractiveTransition:d];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:recognizer.view].y > 0 && location.y > CGRectGetHeight(recognizer.view.bounds) / 3.f) {
            [self finishInteractiveTransition];
        } else {
            [self cancelInteractiveTransition];
        }
    }  else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        [self cancelInteractiveTransition];
    }
}

#pragma mark - UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPop) {
        self.isInteractive = NO;
    }
    self.animator.operation = operation;
    return self.animator;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.isInteractive ? self : nil;
}
@end
