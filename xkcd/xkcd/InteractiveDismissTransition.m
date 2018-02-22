//
//  InteractiveDismissTransition.m
//  xkcd
//
//  Created by mikeller on 2/10/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "InteractiveDismissTransition.h"

#import "DismissTransition.h"

static CGFloat const kPercentThreshold = 0.4F;

@interface InteractiveDismissTransition() <UIViewControllerTransitioningDelegate>
@property (strong, nonatomic, readwrite) DismissTransition *dismissTransition;
@property (nonatomic, readwrite) BOOL hasStarted;
@property (nonatomic, readwrite) BOOL shouldFinish;

@property (nonatomic) CGFloat startingScrollPositionY;
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
  
  // disbale scrolling during transition for UIScrollView.
  BOOL isScrollViewAtTop = YES;
  UIScrollView *scrollView = nil;
  if ([panRecognizer.view isKindOfClass:[UIScrollView class]]) {
    scrollView = (UIScrollView *)view;
    isScrollViewAtTop = scrollView.contentOffset.y <= -scrollView.adjustedContentInset.top;
    BOOL shouldDisallowScrolling = progress > 0.0F && isScrollViewAtTop;
    scrollView.scrollEnabled = !shouldDisallowScrolling;
  }
  
  switch (panRecognizer.state) {
    case UIGestureRecognizerStateBegan:
      if (!isScrollViewAtTop) return;
      
      self.startingPercent = 0.0F;
      self.startingScrollPositionY = scrollView.contentOffset.y;
      self.hasStarted = YES;
      shouldDismiss();
      break;
      
    case UIGestureRecognizerStateChanged:
      if (isScrollViewAtTop && !self.hasStarted) {
        self.hasStarted = YES;
        self.startingPercent = translation.y / view.bounds.size.height;
        shouldDismiss();
      }
      progress -= self.startingPercent;
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

- (CGFloat) progressWithTranslation:(CGPoint)translation viewHeight:(CGFloat)viewHeight {
  CGFloat verticalMovement = (translation.y + self.startingScrollPositionY) / viewHeight;
  CGFloat downwardMovement = fmaxf(verticalMovement, 0.0F);
  CGFloat progress = fminf(downwardMovement, 1.0F);
  return progress;
}

@end
