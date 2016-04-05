//
//  MainViewController.m
//  TransitionControllers
//
//  Created by Valentina Chernoeva on 04.04.16.
//  Copyright © 2016 Valentina Chernoeva. All rights reserved.
//

#import "MainViewController.h"
#import "ImageViewController.h"
#import "UIViewController+Storyboard.h"
#import "NavigationDelegate.h"

@interface MainViewController () <TransitionProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *transitionImageView;
@property (weak, nonatomic) IBOutlet UIView *transitionView;

@property (strong, nonatomic) NavigationDelegate *navigationDelegat;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationDelegat = [[NavigationDelegate alloc] initWithViewController:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self.navigationDelegat;
}

#pragma mark - Actions

- (IBAction)onImageTap:(UITapGestureRecognizer *)sender {
    ImageViewController *vc = [ImageViewController instantiateFromMainStoryboard];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TransitionProtocol

- (UIView *)transitionTopView {
    return self.transitionImageView;
}
- (UIView *)transitionBottomView {
    return self.transitionView;
}
- (UIViewController *)destanationViewController {
    return  [ImageViewController instantiateFromMainStoryboard];
}

@end
