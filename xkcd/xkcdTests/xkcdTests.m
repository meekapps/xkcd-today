//
//  xkcdTests.m
//  xkcdTests
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "NSDate+ShortDate.h"
#import "NSError+Message.h"
#import "NSNumber+Operations.h"
#import "NSString+StripTags.h"
#import "NSString+XKCDImageUrl.h"
#import "TodayViewManager.h"
#import "UIColor+XKCD.h"
#import "UIImage+AsyncImage.h"
#import "UIImage+XKCD.h"
#import "UIStoryboard+XKCD.h"
#import "XKCD.h"

@import XCTest;

@interface xkcdTests : XCTestCase

@end

static NSTimeInterval const kDefaultAsyncTestTimeout = 10;

@implementation xkcdTests

#pragma mark - NSDate+ShortDate

- (void)testShortDate {
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
  NSString *shortDate = [date shortDate];
  XCTAssert([shortDate isEqualToString:@"12/31/69"], @"shortDate: %@", shortDate);
}

#pragma mark - NSError+Message
- (void) testErrorMessage {
  NSError *error = [NSError errorWithDomain:@"domain"
                                       code:42
                                    message:@"message"];
  
  XCTAssert([error.domain isEqualToString:@"domain"]);
  XCTAssert(error.code == 42);
  XCTAssert([error.userInfo[@"error"] isEqualToString:@"message"]);
}

#pragma mark - NSNumber+Operations

- (void) testAdd {
  NSNumber *sum = [@(5) add:3];
  XCTAssert([sum equals:@(8)]);
}

- (void) testEquals {
  NSNumber *five = @(5);
  NSNumber *anotherFive = @(5);
  NSNumber *six = @(6);
  XCTAssertTrue([five equals:anotherFive]);
  XCTAssertFalse([five equals:six]);
}

- (void) testGreaterThan {
  NSNumber *ten = @(10);
  NSNumber *five = @(5);
  XCTAssertTrue([ten greaterThan:five]);
  XCTAssertFalse([five greaterThan:ten]);
}

- (void) testLessThan {
  NSNumber *ten = @(10);
  NSNumber *five = @(5);
  XCTAssertTrue([five lessThan:ten]);
  XCTAssertFalse([ten lessThan:five]);
}

- (void) testSubtract {
  NSNumber *difference = [@(10) subtract:5];
  XCTAssert([difference equals:@(5)]);
}

- (void) testRandom {
  NSNumber *min = @(10);
  NSNumber *max = @(100);
  for (int i = 0; i < 10000; i++) {
    NSNumber *random = [NSNumber randomWithMinimum:min maximum:max];
    XCTAssert([random lessThan:[max add:1]]);
    XCTAssert([random greaterThan:[min subtract:1]]);
  }
}

#pragma mark - NSString+StripTags

- (void) testParagraphTagNewlines {
  NSString *paragraphTags = @"<p>hello<p>world";
  NSString *converted = [paragraphTags convertParagraphTagsToNewlines];
  NSString *expected = @"\nhello\nworld";
  XCTAssert([converted isEqualToString:expected]);
}

- (void) testStripEdits {
  NSString *edits = @"[edit] hello there.";
  NSString *stripped = [edits stripEdits];
  NSString *expected = @"hello there.";
  XCTAssert([stripped isEqualToString:expected]);
}

- (void) testStripTags {
  NSString *html = @"<html><h1>i am html. </h1><h2>hear me roar.</h2></html>";
  NSString *stripped = [html stripTags];
  NSString *expected = @"i am html. hear me roar.";
  XCTAssert([stripped isEqualToString:expected]);
}

- (void) testTrimBeforeExplanation {
  NSString *text = @"Useless metadata. Explanation: The good stuff.";
  NSString *trimmed = [text trimStringBeforeExplanation];
  NSString *expected = @"Explanation: The good stuff.";
  XCTAssert([trimmed isEqualToString:expected]);
}

#pragma mark - NSString+XKCDImageUrl

- (void) testXKCDUrl {
  NSString *url1 = @"testurl";
  BOOL url1Valid = [url1 isValidImageUrl];
  XCTAssertFalse(url1Valid);
  
  NSString *url2 = @"http://testurl";
  BOOL url2Valid = [url2 isValidImageUrl];
  XCTAssertFalse(url2Valid);
  
  NSString *url3 = @"http://testurl.com/image";
  BOOL url3Valid = [url3 isValidImageUrl];
  XCTAssertFalse(url3Valid);
  
  NSString *url4 = @"http://testurl.com/image.svg";
  BOOL url4Valid = [url4 isValidImageUrl];
  XCTAssertFalse(url4Valid);
  
  NSString *url5 = @"http://testurl.com/image.png";
  BOOL url5Valid = [url5 isValidImageUrl];
  XCTAssertTrue(url5Valid);
}

#pragma mark - TodayViewManager

- (void)testTodayViewManager {
    TodayViewManager *todayViewManager = [TodayViewManager sharedManager];
    XCTAssertNotNil(todayViewManager);
}

#pragma mark - UIColor+XKCD

- (void) testColors {
    UIColor *themeColor = [UIColor themeColor];
    XCTAssertNotNil(themeColor);
    
    CGFloat red = 0.0F;
    CGFloat green = 0.0F;
    CGFloat blue = 0.0F;
    CGFloat alpha = 0.0F;
    [themeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    XCTAssert(red == 151.0F/255.0F);
    XCTAssert(green == 169.0F/255.0F);
    XCTAssert(blue == 199.0F/255.0F);
    XCTAssert(alpha == 1.0F);
}

#pragma mark - UIImage+AsyncImage

- (void) testImageFromNilUrl {
    XCTestExpectation *emptyExpectation = [[XCTestExpectation alloc] initWithDescription:@"image should be nil"];
    [UIImage imageFromUrl:nil completion:^(UIImage *image) {
        XCTAssertNil(image);
        [emptyExpectation fulfill];
    }];
    
    [self waitForExpectations:@[emptyExpectation] timeout:kDefaultAsyncTestTimeout];
    
}

#pragma mark - UIImage+XKCD

- (void) testImages {
    UIImage *filledLandscapeImage = [UIImage heartImageFilled:YES
                                                    landscape:YES];
    XCTAssertNotNil(filledLandscapeImage);
    
    UIImage *filledPortraitImage = [UIImage heartImageFilled:YES
                                                   landscape:NO];
    XCTAssertNotNil(filledPortraitImage);
    
    UIImage *unfilledLandscapeImage = [UIImage heartImageFilled:NO
                                                      landscape:YES];
    XCTAssertNotNil(unfilledLandscapeImage);
    
    UIImage *unfilledPortraitImage = [UIImage heartImageFilled:NO
                                                     landscape:NO];
    XCTAssertNotNil(unfilledPortraitImage);
}

#pragma mark - UIStoryboard+XKCD

- (void) testStoryboards {
    UINavigationController *explainedNavigationController = [UIStoryboard explainedRootNavigationController];
    XCTAssertNotNil(explainedNavigationController);
    
    UINavigationController *favoritesNavigationController = [UIStoryboard favoritesRootNavigationController];
    XCTAssertNotNil(favoritesNavigationController);
}

#pragma mark - XKCD

- (void) testXKCD {
    XKCD *xkcd = [XKCD sharedInstance];
    NSArray<XKCDComic *> *comics = [xkcd fetchAllDownloaded];
    XCTAssertNotNil(comics);
}

@end
