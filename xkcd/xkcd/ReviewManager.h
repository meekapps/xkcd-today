//
//  ReviewManager.h
//  xkcd
//
//  Created by Mike Keller on 10/21/17.
//  Copyright © 2017 meek apps. All rights reserved.
//

@import Foundation;

@interface ReviewManager : NSObject

/// YES if review has already been requested for standard user defaults.
@property (nonatomic, readonly, class) BOOL didRequestReview;

/// Returns the number of sessions required to request a review.
@property (nonatomic, readonly, class) NSInteger minimumSessionsToRequestReview;

/// YES if review has already been requested for custom user defaults.
+ (BOOL)didRequestReviewWithUserDefaults:(NSUserDefaults *)userDefaults;

/// Asks for App Store review if session count criteria is met and review has not yet been prompted for standard user defaults.
+ (void)requestReviewIfNeeded;

/// Asks for App Store review if session count criteria is met and review has not yet been prompted for custom user defaults.
+ (void)requestReviewIfNeededWithUserDefaults:(NSUserDefaults *)userDefaults;

@end
