//
//  InteractiveDismissTransition.h
//  xkcd
//
//  Created by mikeller on 2/10/18.
//  Copyright © 2018 Perka. All rights reserved.
//

@import UIKit;

@interface DismissTransition : NSObject <UIViewControllerAnimatedTransitioning>
@end


@interface InteractiveDismissTransition : UIPercentDrivenInteractiveTransition

@property (strong, nonatomic, readonly) DismissTransition *dismissTransition;
@property (nonatomic, readonly) BOOL hasStarted;
@property (nonatomic, readonly) BOOL shouldFinish;

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)panRecognizer
              shouldDismiss:(void(^)(void))shouldDismiss;

@end

@interface InteractiveDismissPresenterViewController : UIViewController
@end
