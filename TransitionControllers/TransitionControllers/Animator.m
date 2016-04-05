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
    
    UIImageView *transitionImageVew = self.transitionImageView;
    UIView* transitionView = self.transitionView;
    
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0.f, CGRectGetHeight(transitionView.bounds));
    
    if (self.operation == UINavigationControllerOperationPush) {
        
        UIView *snapshot = [transitionView snapshotViewAfterScreenUpdates:NO];
        snapshot.frame = [containerView convertRect:transitionView.frame fromView:transitionView.superview];
        [containerView addSubview:snapshot];
        transitionView.hidden = YES;
        
        CGFloat scaleValue = (2.f * CGRectGetHeight(transitionView.bounds) + CGRectGetHeight(transitionImageVew.bounds)) / CGRectGetHeight(transitionImageVew.bounds);
        
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1.f;
            transitionImageVew.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
            snapshot.transform = translation;
        } completion:^(BOOL finished) {
            transitionView.hidden = NO;
            [snapshot removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else if (self.operation == UINavigationControllerOperationPop) {
        transitionView.transform = translation;
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1.f;
            transitionImageVew.transform = CGAffineTransformIdentity;
            transitionView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }    
}

@end
