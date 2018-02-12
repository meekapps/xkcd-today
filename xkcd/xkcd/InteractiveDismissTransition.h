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

@property (strong, nonatomic) DismissTransition *dismissTransition;
@property (nonatomic) BOOL hasStarted;
@property (nonatomic) BOOL shouldFinish;

@end
