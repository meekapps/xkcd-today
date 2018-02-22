//
//  InteractiveDismissPresentingViewController.h
//  xkcd
//
//  Created by mikeller on 2/21/18.
//  Copyright © 2018 Perka. All rights reserved.
//

@import UIKit;

@class InteractiveDismissTransition;

@interface InteractiveDismissPresentingViewController : UIViewController <UIViewControllerTransitioningDelegate>
@property (strong, nonatomic, readonly) InteractiveDismissTransition *interactiveDismissTransition;
@end
