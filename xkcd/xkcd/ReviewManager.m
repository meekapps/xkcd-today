//
//  ReviewManager.m
//  xkcd
//
//  Created by mikeller on 10/21/17.
//  Copyright © 2017 Perka. All rights reserved.
//

@import StoreKit;

#import "ReviewManager.h"
#import "UIApplication+Sessions.h"

static NSString * const kDidRequestReviewKey = @"didRequestReview";
static NSInteger const kMinimumSessionsToRequestReview = 3;

@implementation ReviewManager

+ (BOOL) didRequetReview {
  return [[NSUserDefaults standardUserDefaults] boolForKey:kDidRequestReviewKey];
}

+ (void) requestReviewIfNeeded {
  if ([UIApplication numberOfLoggedSessions] >= kMinimumSessionsToRequestReview &&
    !self.didRequetReview) {
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
