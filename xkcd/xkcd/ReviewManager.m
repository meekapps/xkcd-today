//
//  ReviewManager.m
//  xkcd
//
//  Created by Mike Keller on 10/21/17.
//  Copyright © 2017 meek apps. All rights reserved.
//

@import StoreKit;

#import "ReviewManager.h"
#import "UIApplication+Sessions.h"

static NSString * const kDidRequestReviewKey = @"didRequestReview";
static NSInteger const kMinimumSessionsToRequestReview = 3;

@implementation ReviewManager

+ (BOOL) didRequestReview {
  return [[NSUserDefaults standardUserDefaults] boolForKey:kDidRequestReviewKey];
}

+ (void) requestReviewIfNeeded {
  if ([UIApplication numberOfLoggedSessions] >= kMinimumSessionsToRequestReview &&
    !self.didRequestReview) {
    [SKStoreReviewController requestReview];
    [self setDidRequestReview:YES];
  }
}

#pragma mark - Private

+ (void) setDidRequestReview:(BOOL)didRequestReview {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:didRequestReview forKey:kDidRequestReviewKey];
  [userDefaults synchronize];
}

@end
