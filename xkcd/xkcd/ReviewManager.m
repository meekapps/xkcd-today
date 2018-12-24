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

+ (BOOL)didRequestReview {
    NSUserDefaults *standardUserDefaults = NSUserDefaults.standardUserDefaults;
    return [self didRequestReviewWithUserDefaults:standardUserDefaults];
}

+ (BOOL)didRequestReviewWithUserDefaults:(NSUserDefaults *)userDefaults {
    return [userDefaults boolForKey:kDidRequestReviewKey];
}

+ (NSInteger)minimumSessionsToRequestReview {
    return kMinimumSessionsToRequestReview;
}

+ (void)requestReviewIfNeeded {
    NSUserDefaults *standardUserDefaults = NSUserDefaults.standardUserDefaults;
    [self requestReviewIfNeededWithUserDefaults:standardUserDefaults];
}

+ (void)requestReviewIfNeededWithUserDefaults:(NSUserDefaults *)userDefaults {
    if ([UIApplication numberOfLoggedSessionsWithUserDefaults:userDefaults] >= kMinimumSessionsToRequestReview &&
        !self.didRequestReview) {
        [SKStoreReviewController requestReview];
        [self setDidRequestReview:YES userDefaults:userDefaults];
    }
}

#pragma mark - Private

+ (void)setDidRequestReview:(BOOL)didRequestReview userDefaults:(NSUserDefaults *)userDefaults {
  [userDefaults setBool:didRequestReview forKey:kDidRequestReviewKey];
  [userDefaults synchronize];
}

@end
