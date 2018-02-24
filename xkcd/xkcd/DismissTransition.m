//
//  DismissTransition.m
//  xkcd
//
//  Created by Mike Keller on 2/21/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "DismissTransition.h"

@import UIKit;

static NSTimeInterval const kAnimationDuration = 0.3;

@implementation DismissTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
  return kAnimationDuration;
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
