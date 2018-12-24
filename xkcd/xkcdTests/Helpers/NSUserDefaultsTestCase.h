//
//  NSUserDefaultsTestCase.h
//  xkcd
//
//  Created by Mike Keller on 12/24/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

@import Foundation;

#import <XCTest/XCTest.h>

@interface NSUserDefaultsTestCase : XCTestCase

@property (nonatomic, strong, readonly) NSUserDefaults *userDefaults;

@end
