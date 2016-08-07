//
//  UIStoryboard+XKCD.m
//  xkcd
//
//  Created by Mike Keller on 8/7/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "UIStoryboard+XKCD.h"

@implementation UIStoryboard (XKCD)

+ (UINavigationController*) explainedRootNavigationController {
  return [self rootNavigationControllerWithName:@"Explained"];
}

+ (UINavigationController*) favoritesRootNavigationController {
  return [self rootNavigationControllerWithName:@"Favorites"];
}

#pragma mark - Private

+ (UINavigationController*) rootNavigationControllerWithName:(NSString*)storyboardName {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName
                                                       bundle:[NSBundle mainBundle]];
  UINavigationController *favoritesNavigationController = [storyboard instantiateInitialViewController];
  return favoritesNavigationController;
}

@end
