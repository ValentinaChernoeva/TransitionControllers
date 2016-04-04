//
//  PanGestureInteractiveTransition.m
//  TransitionControllers
//
//  Created by Valentina Chernoeva on 04.04.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//


#import "PanGestureInteractiveTransition.h"
#import "Utilits.h"
#import "Animator.h"

@interface PanGestureInteractiveTransition ()

@end


@implementation PanGestureInteractiveTransition

- (instancetype)initWithGestureRecognizerInViewController:(UIViewController *)recognizerVC recognizedBlock:(GestureInteractivePanHandler)gestureRecognizedBlock {
    self = [super init];
    if (self) {
        self.gestureRecognizedBlock = gestureRecognizedBlock;
        self.recognizerVC = recognizerVC;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandler:)];
        [recognizerVC.view addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)gestureHandler:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint location = [recognizer locationInView:recognizer.view];
    CGPoint tranlation = [recognizer translationInView:recognizer.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        PERFORM_BLOCK_IF_NOT_NIL(self.gestureRecognizedBlock, recognizer);
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat d = tranlation.y / CGRectGetHeight(recognizer.view.bounds);
        [self updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:recognizer.view].y > 0 && location.y > CGRectGetHeight(recognizer.view.bounds) * 0.66f) {
            [self finishInteractiveTransition];
        } else {
            [self cancelInteractiveTransition];
        }
    }
}

@end
