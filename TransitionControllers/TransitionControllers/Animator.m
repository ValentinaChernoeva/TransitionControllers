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
    
    UIView *transitionTopView = self.transitionTopView;
    UIView* transitionBottomView = self.transitionBottomView;
    
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0.f, CGRectGetHeight(transitionBottomView.bounds));
    
    if (self.operation == UINavigationControllerOperationPush) {
        
        UIView *snapshot = [transitionBottomView snapshotViewAfterScreenUpdates:NO];
        snapshot.frame = [containerView convertRect:transitionBottomView.frame fromView:transitionBottomView.superview];
        [containerView addSubview:snapshot];
        transitionBottomView.hidden = YES;
        
        CGFloat scaleValue = (2.f * CGRectGetHeight(transitionBottomView.bounds) + CGRectGetHeight(transitionTopView.bounds)) / CGRectGetHeight(transitionTopView.bounds);
        
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1.f;
            transitionTopView.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
            snapshot.transform = translation;
        } completion:^(BOOL finished) {
            transitionBottomView.hidden = NO;
            [snapshot removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else if (self.operation == UINavigationControllerOperationPop) {
        transitionBottomView.transform = translation;
        [UIView animateWithDuration:duration animations:^{
            toViewController.view.alpha = 1.f;
            transitionTopView.transform = CGAffineTransformIdentity;
            transitionBottomView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }    
}

@end
