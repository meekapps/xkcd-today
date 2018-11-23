//
//  InteractiveDismissPresentedViewController.h
//  xkcd
//
//  Created by Mike Keller on 2/21/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

@import UIKit;

@class InteractiveDismissTransition;
@class InteractiveDismissPresentingViewController;

@interface InteractiveDismissPresentedViewController : UIViewController

/// To be set by subclass.
@property (weak, nonatomic) UIView *interactiveDismissTransitionView;

/// To be set by presenting view controller.
@property (weak, nonatomic) InteractiveDismissPresentingViewController *interactiveDismissPresentingViewController;

@end
