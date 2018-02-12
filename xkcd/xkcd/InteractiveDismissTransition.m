//
//  InteractiveDismissTransition.m
//  xkcd
//
//  Created by mikeller on 2/10/18.
//  Copyright © 2018 Perka. All rights reserved.
//

#import "InteractiveDismissTransition.h"

static CGFloat const kPercentThreshold = 0.3F;
static NSTimeInterval const kAnimationDuration = 0.3;

@implementation InteractiveDismissTransition

- (DismissTransition *) dismissTransition {
  if (!_dismissTransition) {
    _dismissTransition = [[DismissTransition alloc] init];
  }
  return _dismissTransition;
}

- (void) handlePanRecognizer:(UIPanGestureRecognizer *)panRecognizer
                        view:(UIView *)view
               shouldDismiss:(void(^)(void))shouldDismiss {
  CGPoint translation = [panRecognizer translationInView:view];
  CGFloat progress = [self progressWithTranslation:translation viewHeight:CGRectGetHeight(view.bounds)];
  
  UIScrollView *scrollView = [panRecognizer.view isKindOfClass:[UIScrollView class]] ? (UIScrollView *)panRecognizer.view : nil;
  
  CGPoint topOffset = CGPointMake(0.0F, -view.layoutMarginsGuide.layoutFrame.origin.y);
  if ([panRecognizer.view isKindOfClass:[UIScrollView class]] && scrollView.contentOffset.y > topOffset.y && self.hasStarted) {
    [self cancelInteractiveTransition];
    return;
  }
  
  if (scrollView) {
    scrollView.contentOffset = topOffset;
  }
  
  switch (panRecognizer.state) {
    case UIGestureRecognizerStateBegan:
      self.hasStarted = YES;
      shouldDismiss();
      break;
      
    case UIGestureRecognizerStateChanged:
      self.shouldFinish = progress > kPercentThreshold;
      [self updateInteractiveTransition:progress];
      break;
      
    case UIGestureRecognizerStateCancelled:
      self.hasStarted = NO;
      [self cancelInteractiveTransition];
      break;
      
    case UIGestureRecognizerStateEnded:
      self.hasStarted = NO;
      self.shouldFinish ? [self finishInteractiveTransition] : [self cancelInteractiveTransition];
      break;
      
    default:
      // Do nothing
      break;
  }
}

#pragma mark - Private

- (CGFloat) progressWithTranslation:(CGPoint)translation viewHeight:(CGFloat)viewHeight{
  CGFloat verticalMovement = translation.y / viewHeight;
  CGFloat downwardMovement = fmaxf(verticalMovement, 0.0F);
  CGFloat progress = fminf(downwardMovement, 1.0F);
  return progress;
}

@end


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
