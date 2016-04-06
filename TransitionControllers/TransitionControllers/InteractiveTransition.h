//
//  InteractiveTransition.h
//  TransitionControllers
//
//  Created by Valentina Chernoeva on 06.04.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Animator;

typedef void(^InteractiveHandler)(UIPanGestureRecognizer *recognizer);

@interface InteractiveTransition : UIPercentDrivenInteractiveTransition <UINavigationControllerDelegate>

@property (copy, nonatomic) InteractiveHandler gestureRecognizedBlock;
@property (strong, nonatomic) Animator *animator;

- (instancetype)initWithGestureRecognizerInView:(UIView *)view
                                       animator:(Animator *)animator
                                recognizedBlock:(InteractiveHandler)gestureRecognizedBlock;


@end
