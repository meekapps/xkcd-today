//
//  UINavigationItem+Animate.m
//  xkcd
//
//  Created by Mike Keller on 8/6/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "UINavigationItem+Animate.h"

static CFTimeInterval kUINavigationItemAnimationDefaultDuration = 0.12;

@implementation UINavigationItem (Animate)

- (void) setTitle:(NSString *)title
  inNavigationBar:(UINavigationBar*)navigationBar
         animated:(BOOL)animated {
  if (animated) {
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = kUINavigationItemAnimationDefaultDuration;
    fadeTextAnimation.type = kCATransitionFade;
    
    [navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
  }
  self.title = title;
}

@end
