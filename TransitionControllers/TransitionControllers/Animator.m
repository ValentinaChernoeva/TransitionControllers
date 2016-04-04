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
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0.f;
    
    [containerView addSubview:toViewController.view];

    if ([fromViewController isKindOfClass:[MainViewController class]]) {
        
        UIView *fromView = ((MainViewController *)fromViewController).transitionImageView;
        UIView *toView = ((ImageViewController *)toViewController).transitionImageView;
        UIView *topView = ((MainViewController *)fromViewController).containerView;
        toView.hidden = YES;
        
        UIView *fromSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
        fromSnapshot.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
        fromView.hidden = YES;
        
        UIView *topSnapshot = [topView snapshotViewAfterScreenUpdates:NO];
        topSnapshot.frame = [containerView convertRect:topView.frame fromView:topView.superview];
        topView.hidden = YES;
        
        [containerView addSubview:fromSnapshot];
        [containerView addSubview:topSnapshot];
        CGRect newFrame = CGRectMake(0.f, CGRectGetMinY(topSnapshot.frame) + CGRectGetMidY(topSnapshot.bounds), CGRectGetWidth(topSnapshot.bounds), CGRectGetMidY(topSnapshot.bounds));
        CGFloat scaleValue = (2.f * CGRectGetHeight(newFrame) + CGRectGetHeight(fromSnapshot.bounds)) / CGRectGetHeight(fromSnapshot.bounds);
        [UIView animateWithDuration:duration / 2.f animations:^{
            toViewController.view.alpha = 1.f;
            fromSnapshot.transform =  CGAffineTransformMakeScale(scaleValue, scaleValue);
            topSnapshot.frame = newFrame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration / 2.f animations:^{
                topSnapshot.alpha = 0.f;
                fromSnapshot.frame = toView.frame;
            } completion:^(BOOL finished) {
                toView.hidden = NO;
                fromView.hidden = NO;
                topView.hidden = NO;
                fromSnapshot.transform = CGAffineTransformIdentity;
                [fromSnapshot removeFromSuperview];
                [topSnapshot removeFromSuperview];
                [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
            }];
        }];
        
    } else {
        
        UIView *fromView = ((ImageViewController *)fromViewController).transitionImageView;
        UIView *toView = ((MainViewController *)toViewController).transitionImageView;
        toView.hidden = YES;
        
        UIView *fromSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
        fromSnapshot.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
        fromView.hidden = YES;
        
        [containerView addSubview:fromSnapshot];
        
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1.f;
            fromSnapshot.frame = toView.frame;
        } completion:^(BOOL finished) {
            fromView.hidden = NO;
            toView.hidden = NO;
            
            [fromSnapshot removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];

        }];

    }
}

@end
