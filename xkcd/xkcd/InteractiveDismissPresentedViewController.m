//
//  InteractiveDismissPresentedViewController.m
//  xkcd
//
//  Created by mikeller on 2/21/18.
//  Copyright © 2018 Perka. All rights reserved.
//

#import "InteractiveDismissPresentedViewController.h"

#import "InteractiveDismissPresentingViewController.h"
#import "InteractiveDismissTransition.h"

@interface InteractiveDismissPresentedViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) InteractiveDismissTransition *interactiveDismissTransition;
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@end

@implementation InteractiveDismissPresentedViewController

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  NSAssert(self.interactiveDismissTransitionView, @"Subclass should set interactiveDismissTransitionView");
  NSAssert(self.interactiveDismissPresentingViewController, @"Subclass should set interactiveDismissPresentingViewController");
}

- (void) setInteractiveDismissTransitionView:(UIView *)interactiveDismissTransitionView {
  _interactiveDismissTransitionView = interactiveDismissTransitionView;

  [_interactiveDismissTransitionView addGestureRecognizer:self.panRecognizer];
}

- (void)setInteractiveDismissPresentingViewController:(InteractiveDismissPresentingViewController *)interactiveDismissPresentingViewController {
  _interactiveDismissPresentingViewController = interactiveDismissPresentingViewController;
  self.interactiveDismissTransition = interactiveDismissPresentingViewController.interactiveDismissTransition;
  
  UIViewController *viewController = self.navigationController ?: self;
  viewController.transitioningDelegate = interactiveDismissPresentingViewController;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

#pragma mark - Private

- (void) commonInit {
  _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
  _panRecognizer.delegate = self;
}

- (void) pan:(UIPanGestureRecognizer *)sender {
  UIViewController *viewController = self.navigationController ?: self;
  [self.interactiveDismissTransition handlePanRecognizer:sender shouldDismiss:^{
    [viewController dismissViewControllerAnimated:YES completion:nil];
  }];
}

@end
