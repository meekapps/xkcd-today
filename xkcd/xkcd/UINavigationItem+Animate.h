//
//  UINavigationItem+Animate.h
//  xkcd
//
//  Created by Mike Keller on 8/6/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Animate)

- (void) setTitle:(NSString *)title
  inNavigationBar:(UINavigationBar*)navigationBar
         animated:(BOOL)animated;

@end
