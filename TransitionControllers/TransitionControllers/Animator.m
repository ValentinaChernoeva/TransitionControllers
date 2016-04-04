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
    
    [UIView animateWithDuration:duration / 2.f animations:^{
        toViewController.view.alpha = 1.f;
        fromSnapshot.transform =  CGAffineTransformMakeScale(3.f, 3.f);
        topSnapshot.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.f, 0.5f), CGAffineTransformMakeTranslation(0.f, CGRectGetMidY(topSnapshot.bounds)));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration / 2.f animations:^{
            topSnapshot.alpha = 0.f;
            fromSnapshot.frame = toView.frame;
        } completion:^(BOOL finished) {
            toView.hidden = NO;
            fromView.hidden = NO;
            topView.hidden = NO;
            topSnapshot.transform = CGAffineTransformIdentity;
            fromSnapshot.transform = CGAffineTransformIdentity;
            [fromSnapshot removeFromSuperview];
            [topSnapshot removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }];
    
}

@end
