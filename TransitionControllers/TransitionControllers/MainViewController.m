//
//  MainViewController.m
//  TransitionControllers
//
//  Created by Valentina Chernoeva on 04.04.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//

#import "MainViewController.h"
#import "Animator.h"
#import "ImageViewController.h"
#import "InteractiveTransition.h"
#import "UIViewController+Storyboard.h"


@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *transitionImageView;
@property (weak, nonatomic) IBOutlet UIView *transitionView;

@property (strong, nonatomic) InteractiveTransition *interactiveTransition;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Animator *animator = [[Animator alloc] init];
    animator.transitionTopView = self.transitionImageView;
    animator.transitionBottomView = self.transitionView;
    __weak typeof(self) wSelf = self;
    self.interactiveTransition = [[InteractiveTransition alloc] initWithGestureRecognizerInView:self.transitionView animator:animator recognizedBlock:^(UIPanGestureRecognizer *recognizer) {
        ImageViewController *vc = [ImageViewController instantiateFromMainStoryboard];
        [wSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self.interactiveTransition;
}

#pragma mark - Actions

- (IBAction)onImageTap:(UITapGestureRecognizer *)sender {
    ImageViewController *vc = [ImageViewController instantiateFromMainStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
