//
//  ReviewManagerTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "NSUserDefaultsTestCase.h"
#import "ReviewManager.h"
#import "UIApplication+Sessions.h"
#import <XCTest/XCTest.h>

@interface ReviewManagerTests : NSUserDefaultsTestCase
@end

@implementation ReviewManagerTests

#pragma mark - Tests

- (void)testMinimumSessions {
    NSInteger minimumSessions = ReviewManager.minimumSessionsToRequestReview;
    XCTAssertEqual(3, minimumSessions);
}

- (void)testStartingDidRequestReview {
    BOOL didRequestReview = [ReviewManager didRequestReviewWithUserDefaults:self.userDefaults];
    XCTAssertEqual(NO, didRequestReview);
}

- (void)testRequestReview {
    for (NSInteger i = 0; i < ReviewManager.minimumSessionsToRequestReview; i++) {
        XCTAssertFalse([ReviewManager didRequestReviewWithUserDefaults:self.userDefaults]);
        [UIApplication logSessionWithUserDefaults:self.userDefaults];
        [ReviewManager requestReviewIfNeededWithUserDefaults:self.userDefaults];
    }
    
    XCTAssertTrue([ReviewManager didRequestReviewWithUserDefaults:self.userDefaults]);
}

@end
