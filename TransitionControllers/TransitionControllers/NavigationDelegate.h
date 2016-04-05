//
//  NavigationDelegate.h
//  TransitionControllers
//
//  Created by Valentina Chernoeva on 05.04.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TransitionProtocol <NSObject>

@property (readonly) UIView *transitionTopView;
@property (readonly) UIView *transitionBottomView;
@property (readonly) UIViewController *destanationViewController;

@end

@interface NavigationDelegate : NSObject <UINavigationControllerDelegate>

- (instancetype)initWithViewController:(UIViewController <TransitionProtocol>*)viewController;

@end
