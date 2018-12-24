//
//  XKCDTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "XKCD.h"
#import <XCTest/XCTest.h>

@interface XKCDTests : XCTestCase

@end

@implementation XKCDTests

#pragma mark - Tests

- (void)testXKCD {
    XKCD *xkcd = [XKCD sharedInstance];
    NSArray<XKCDComic *> *comics = [xkcd fetchAllDownloaded];
    XCTAssertNotNil(comics);
    
    XCTAssertFalse([xkcd comicIsBlacklisted:@1]);
    XCTAssertTrue([xkcd comicIsBlacklisted:@1608]);
}

@end
