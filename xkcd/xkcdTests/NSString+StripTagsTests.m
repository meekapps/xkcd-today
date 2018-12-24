//
//  NSString+StripTagsTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "NSString+StripTags.h"
#import <XCTest/XCTest.h>

@interface NSString_StripTagsTests : XCTestCase

@end

@implementation NSString_StripTagsTests

#pragma mark - Tests

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
@end
