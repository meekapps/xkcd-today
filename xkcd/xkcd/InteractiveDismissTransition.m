//
//  InteractiveDismissTransition.m
//  xkcd
//
//  Created by mikeller on 2/10/18.
//  Copyright © 2018 Perka. All rights reserved.
//

#import "InteractiveDismissTransition.h"

@implementation InteractiveDismissTransition

- (DismissTransition *)dismissTransition {
  if (!_dismissTransition) {
    _dismissTransition = [[DismissTransition alloc] init];
  }
  return _dismissTransition;
}

@end


@implementation DismissTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.3F;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  UIView *containerView = transitionContext.containerView;
  
  if (!fromViewController || !toViewController || !containerView) {
    [transitionContext completeTransition:NO];
    return;
  }
  
  [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
  
  CGRect endFrame = fromViewController.view.frame;
  endFrame.origin.y = CGRectGetHeight(fromViewController.view.bounds);
  [UIView animateWithDuration:[self transitionDuration:transitionContext]
                   animations:^{
                     fromViewController.view.frame = endFrame;
                   } completion:^(BOOL finished) {
                     [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                   }];
}

@end
