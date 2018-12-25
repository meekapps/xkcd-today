//
//  XKCDTests.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "PersistenceManager.h"
#import "XKCD.h"
#import <XCTest/XCTest.h>

@interface XKCDTests : XCTestCase
@property (nonatomic, strong) XKCD *xkcd;
@end

@implementation XKCDTests

#pragma mark - Lifecycle

- (void)setUp {
    [super setUp];
    
    PersistenceManager *persistenceManager = [[PersistenceManager alloc] init];
    self.xkcd = [[XKCD alloc] initWithPersistenceManager:persistenceManager];
}

- (void)tearDown {
    self.xkcd = nil;
    
    [super tearDown];
}

#pragma mark - Tests

- (void)testBlacklisted {
    XCTAssertFalse([self.xkcd comicIsBlacklisted:@1]);
    XCTAssertTrue([self.xkcd comicIsBlacklisted:@1608]);
}

- (void)testFetchAllDownloaded {
    NSArray<XKCDComic *> *comics = [self.xkcd fetchAllDownloaded];
    XCTAssertNotNil(comics);
}

- (void)testToggleFavorites {
    [self.xkcd toggleFavorite:@0];
    NSArray<XKCDComic *> *favorites = self.xkcd.fetchFavorites;
}

@end
