//
//  PanInteractiveTransition.m
//  xkcd
//
//  Created by mikeller on 2/10/18.
//  Copyright © 2018 Perka. All rights reserved.
//

#import "PanInteractiveTransition.h"

@implementation PanInteractiveTransition

- (DismissTransition *)dismissTransition {
  if (!_dismissTransition) {
    _dismissTransition = [[DismissTransition alloc] init];
  }
  return _dismissTransition;
}

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)panRecognizer
                       view:(UIView *)view 
              shouldDismiss:(void(^)(void))shouldDismiss {
  CGFloat percentThreshold = 0.3F;
  // convert y-position to downward pull progress (percentage)
  
  CGPoint translation = [panRecognizer translationInView:view];
  CGFloat verticalMovement = translation.y / CGRectGetHeight(view.bounds);
  CGFloat downwardMovement = fmaxf(verticalMovement, 0.0F);
  CGFloat progress = fminf(downwardMovement, 1.0F);
  
  switch (panRecognizer.state) {
    case UIGestureRecognizerStateBegan:
      self.hasStarted = YES;
      shouldDismiss();
      break;
      
    case UIGestureRecognizerStateChanged:
      self.shouldFinish = progress > percentThreshold;
      [self updateInteractiveTransition:progress];
      break;
      
    case UIGestureRecognizerStateCancelled:
      self.hasStarted = NO;
      [self cancelInteractiveTransition];
      break;
      
    case UIGestureRecognizerStateEnded:
      self.hasStarted = NO;
      if (self.shouldFinish) {
        [self finishInteractiveTransition];
      } else {
        [self cancelInteractiveTransition];
      }
      break;
      
    default:
      // Do nothing
      break;
  }
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
