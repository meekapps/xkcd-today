//
//  InteractiveDismissPresentingViewController.m
//  xkcd
//
//  Created by mikeller on 2/21/18.
//  Copyright © 2018 Perka. All rights reserved.
//

#import "InteractiveDismissPresentingViewController.h"

#import "DismissTransition.h"
#import "InteractiveDismissTransition.h"

@interface InteractiveDismissPresentingViewController ()
@property (strong, nonatomic, readwrite) InteractiveDismissTransition *interactiveDismissTransition;
@end

@implementation InteractiveDismissPresentingViewController

- (InteractiveDismissTransition *) interactiveDismissTransition {
  if (!_interactiveDismissTransition) {
    _interactiveDismissTransition = [[InteractiveDismissTransition alloc] init];
  }
  return _interactiveDismissTransition;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
  return self.interactiveDismissTransition.hasStarted ? self.interactiveDismissTransition : nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
  return self.interactiveDismissTransition.dismissTransition;
}

@end
