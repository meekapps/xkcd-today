//
//  InteractiveDismissPresentedViewController.m
//  xkcd
//
//  Created by Mike Keller on 2/21/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "InteractiveDismissPresentedViewController.h"

#import "InteractiveDismissPresentingViewController.h"
#import "InteractiveDismissTransition.h"

@interface InteractiveDismissPresentedViewController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
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

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  
  if (editing) {
    [self.interactiveDismissTransitionView removeGestureRecognizer:self.panRecognizer];
  } else {
    [self.interactiveDismissTransitionView addGestureRecognizer:self.panRecognizer];
  }
}

- (void) setInteractiveDismissTransitionView:(UIView *)interactiveDismissTransitionView {
  _interactiveDismissTransitionView = interactiveDismissTransitionView;

  [_interactiveDismissTransitionView addGestureRecognizer:self.panRecognizer];
  
  if ([interactiveDismissTransitionView isKindOfClass:UIScrollView.class]) {
    UIScrollView *scrollView = (UIScrollView *)interactiveDismissTransitionView;
    scrollView.delegate = self;
  }
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  // prevent scrolling during transition.
  if (self.interactiveDismissTransition.hasStartedInteractiveTransition) {
    scrollView.contentOffset = self.interactiveDismissTransition.startingScrollPosition;
  }
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
