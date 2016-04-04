//
//  PanGestureInteractiveTransition.h
//  TransitionControllers
//
//  Created by Valentina Chernoeva on 04.04.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Animator;

typedef void(^GestureInteractivePanHandler)(UIPanGestureRecognizer *recognizer);

@interface PanGestureInteractiveTransition : UIPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizerInViewController:(UIViewController *)recognizerVC recognizedBlock:(GestureInteractivePanHandler)gestureRecognizedBlock;

@property (strong, nonatomic) Animator *animator;
@property (weak, nonatomic) UIViewController *recognizerVC;

@property (copy, nonatomic) GestureInteractivePanHandler gestureRecognizedBlock;

@end
