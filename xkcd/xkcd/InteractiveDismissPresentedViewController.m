//
//  InteractiveDismissPresentedViewController.m
//  xkcd
//
//  Created by mikeller on 2/21/18.
//  Copyright © 2018 Perka. All rights reserved.
//

#import "InteractiveDismissPresentedViewController.h"

#import "InteractiveDismissTransition.h"

@interface InteractiveDismissPresentedViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@end

@implementation InteractiveDismissPresentedViewController

- (void) viewDidLoad {
  [super viewDidLoad];

  self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
  self.panRecognizer.delegate = self;
}

- (void) setInteractiveDismissTransitionView:(UIView *)interactiveDismissTransitionView {
  _interactiveDismissTransitionView = interactiveDismissTransitionView;

  [_interactiveDismissTransitionView addGestureRecognizer:self.panRecognizer];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

#pragma mark - Private

- (void) pan:(UIPanGestureRecognizer *)sender {
  UIViewController *viewController = self.navigationController ?: self;
  [self.interactiveDismissTransition handlePanRecognizer:sender shouldDismiss:^{
    [viewController dismissViewControllerAnimated:YES completion:nil];
  }];
}

@end
