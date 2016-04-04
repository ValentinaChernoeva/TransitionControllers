//
//  UIViewController+Storyboard.m
//  TransitionTest
//
//  Created by Valentina Chernoeva on 28.03.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//

#import "UIViewController+Storyboard.h"

NSString *const storyboardNameMain = @"Main";

@implementation UIViewController (Storyboard)

+ (instancetype)instantiateFromMainStoryboard {
    return [self instantiateFromStoryboardNamed:storyboardNameMain];
}

+ (instancetype)instantiateFromStoryboardNamed:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:[self storyboardIdentifier]];
}

+ (NSString *)storyboardIdentifier {
    return NSStringFromClass(self);
}
@end
