//
//  ReviewManager.h
//  xkcd
//
//  Created by mikeller on 10/21/17.
//  Copyright © 2017 Perka. All rights reserved.
//

@import Foundation;

@interface ReviewManager : NSObject

/// YES if review has already been requested.
@property (nonatomic, readonly, class) BOOL didRequetReview;

/// Asks for App Store review if session count criteria is met and review has not yet been prompted.
+ (void) requestReviewIfNeeded;

@end
