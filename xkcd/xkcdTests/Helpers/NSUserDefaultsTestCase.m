//
//  NSUserDefaultsTestCase.m
//  xkcdTests
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "NSUserDefaultsTestCase.h"
#import <XCTest/XCTest.h>

static NSString *const kUserDefaultsTestSuiteName = @"TestSuiteName";

@interface NSUserDefaultsTestCase()
@property (nonatomic, strong, readwrite) NSUserDefaults *userDefaults;
@end

@implementation NSUserDefaultsTestCase

#pragma mark - Lifecycle

- (void)setUp {
    [super setUp];
    
    self.userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kUserDefaultsTestSuiteName];
}

- (void)tearDown {
    [self.userDefaults removePersistentDomainForName:kUserDefaultsTestSuiteName];
    self.userDefaults = nil;
    
    [super tearDown];
}

@end
