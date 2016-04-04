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
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *fromView = nil;
    UIView *toView = nil;
    UIView *topView = nil;
    if ([fromViewController isKindOfClass:[MainViewController class]]) {
        fromView = ((MainViewController *)fromViewController).transitionImageView;
        toView = ((ImageViewController *)toViewController).transitionImageView;
        topView = ((MainViewController *)fromViewController).containerView;
    } else {
        fromView = ((ImageViewController *)fromViewController).transitionImageView;
        toView = ((MainViewController *)toViewController).transitionImageView;
    }
    
    UIView *fromSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    fromSnapshot.frame = [containerView convertRect:fromView.frame fromView:fromView.superview];
    fromView.hidden = YES;
    
    UIView *topSnapshot = [topView snapshotViewAfterScreenUpdates:NO];
    topSnapshot.frame = [containerView convertRect:topView.frame fromView:topView.superview];
    topView.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0.f;
    toView.hidden = YES;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromSnapshot];
    [containerView addSubview:topSnapshot];
    
    CGFloat scaleValue = CGRectGetHeight(fromViewController.view.bounds) / CGRectGetHeight(fromSnapshot.bounds);
    CGRect translationRect = CGRectMake(0.f, 0.f, CGRectGetWidth(fromViewController.view.bounds), CGRectGetHeight(fromViewController.view.bounds) - CGRectGetHeight(fromSnapshot.bounds));
    CGAffineTransform scale = CGAffineTransformMakeScale(scaleValue, scaleValue);
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0.f, CGRectGetMidY(translationRect) - fromView.center.y);
    
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.alpha = 1.f;
        fromSnapshot.transform = CGAffineTransformConcat(scale, translation);
        topSnapshot.frame = CGRectMake(0.f, CGRectGetHeight(translationRect), CGRectGetWidth(fromViewController.view.bounds), CGRectGetHeight(fromViewController.view.bounds) - CGRectGetHeight(translationRect));
    } completion:^(BOOL finished) {
        topSnapshot.alpha = 0.f;
        [UIView animateWithDuration:duration animations:^{
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
    
}

@end
