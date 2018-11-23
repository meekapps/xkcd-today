//
//  InteractiveDismissTransition.h
//  xkcd
//
//  Created by Mike Keller on 2/10/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

@import UIKit;

@class DismissTransition;

@interface InteractiveDismissTransition : UIPercentDrivenInteractiveTransition

@property (strong, nonatomic, readonly) DismissTransition *dismissTransition;
@property (nonatomic, readonly) BOOL hasStartedInteractiveTransition;
@property (nonatomic, readonly) CGPoint startingScrollPosition;

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)panRecognizer
              shouldDismiss:(void(^)(void))shouldDismiss;

@end
