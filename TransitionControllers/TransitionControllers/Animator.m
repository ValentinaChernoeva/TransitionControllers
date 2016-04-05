//
//  Animator.m
//  TransitionControllers
//
//  Created by Valentina Chernoeva on 04.04.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//

#import "Animator.h"
#import "MainViewController.h"
#import "ImageViewController.h"

@implementation Animator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView addSubview:toViewController.view];
    toViewController.view.alpha = 0.f;
    
    UIImageView *imageVew = self.transitionImageView;
    UIView* view = self.transitionView;
    
    if (self.operation == UINavigationControllerOperationPush) {
 
        CGFloat scaleValue = (2.f * CGRectGetHeight(view.bounds) + CGRectGetHeight(imageVew.bounds)) / CGRectGetHeight(imageVew.bounds);
        
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1.f;
            imageVew.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
            view.transform = CGAffineTransformMakeTranslation(0.f, CGRectGetHeight(view.bounds));
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else if (self.operation == UINavigationControllerOperationPop) {
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1.f;
            imageVew.transform = CGAffineTransformIdentity;
            view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }    
}

@end
