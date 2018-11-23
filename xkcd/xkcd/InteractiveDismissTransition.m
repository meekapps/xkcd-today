//
//  InteractiveDismissTransition.m
//  xkcd
//
//  Created by Mike Keller on 2/10/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "InteractiveDismissTransition.h"

#import "DismissTransition.h"

static CGFloat const kScrollMultiplier = 1.2F;
static CGFloat const kPercentThreshold = 0.4F;

@interface InteractiveDismissTransition() <UIViewControllerTransitioningDelegate>
@property (strong, nonatomic, readwrite) DismissTransition *dismissTransition;
@property (nonatomic, readwrite) BOOL hasStartedInteractiveTransition;
@property (nonatomic) BOOL shouldFinishInteractiveTransition;

@property (nonatomic, readwrite) CGPoint startingScrollPosition;
@property (nonatomic) CGFloat startingPercent;
@end

@implementation InteractiveDismissTransition

- (DismissTransition *) dismissTransition {
  if (!_dismissTransition) {
    _dismissTransition = [[DismissTransition alloc] init];
  }
  return _dismissTransition;
}

- (void) handlePanRecognizer:(UIPanGestureRecognizer *)panRecognizer
               shouldDismiss:(void(^)(void))shouldDismiss {
  UIView *view = panRecognizer.view;
  CGPoint translation = [panRecognizer translationInView:view];
  CGFloat progress = [self progressWithTranslation:translation viewHeight:CGRectGetHeight(view.bounds)];
  
  BOOL isViewScrolledToTop = YES;
  UIScrollView *scrollView = nil;
  if ([panRecognizer.view isKindOfClass:[UIScrollView class]]) {
    scrollView = (UIScrollView *)view;
    isViewScrolledToTop = scrollView.contentOffset.y <= -scrollView.adjustedContentInset.top;
  }
  
  switch (panRecognizer.state) {
    case UIGestureRecognizerStateBegan:
      if (!isViewScrolledToTop) return;
      
      self.startingPercent = 0.0F;
      self.startingScrollPosition = scrollView.contentOffset;
      self.hasStartedInteractiveTransition = YES;
      
      shouldDismiss();
      break;
      
    case UIGestureRecognizerStateChanged:
      if (isViewScrolledToTop && !self.hasStartedInteractiveTransition) {
        self.hasStartedInteractiveTransition = YES;
        self.startingPercent = translation.y / view.bounds.size.height;
        shouldDismiss();
      }
      progress -= self.startingPercent;
      self.shouldFinishInteractiveTransition = progress > kPercentThreshold;
      [self updateInteractiveTransition:progress];
      break;
      
    case UIGestureRecognizerStateCancelled:
      self.hasStartedInteractiveTransition = NO;
      [self cancelInteractiveTransition];
      break;
      
    case UIGestureRecognizerStateEnded:
      self.hasStartedInteractiveTransition = NO;
      self.shouldFinishInteractiveTransition ? [self finishInteractiveTransition] : [self cancelInteractiveTransition];
      break;
      
    default:
      // Do nothing
      break;
  }
}

#pragma mark - Private

- (CGFloat) progressWithTranslation:(CGPoint)translation viewHeight:(CGFloat)viewHeight {
  CGFloat verticalMovement = (translation.y + self.startingScrollPosition.y) / viewHeight;
  CGFloat downwardMovement = fmaxf(verticalMovement, 0.0F);
  CGFloat progress = fminf(downwardMovement * kScrollMultiplier, 1.0F);
  return progress;
}

@end
