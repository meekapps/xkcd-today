//
//  UIApplication+Sessions.h
//  xkcd
//
//  Created by Mike Keller on 10/21/17.
//  Copyright © 2017 meek apps. All rights reserved.
//

@import UIKit;

@interface UIApplication (Sessions)

/// The total number of times logSession has been called for standard user defaults.
@property (nonatomic, readonly, class) NSInteger numberOfLoggedSessions;

/// Call to log session and increment numberOfSessions with standard user defaults. Should generally be called from application:DidFinishLaunching.
+ (void)logSession;

/// Call to log session and increment numberOfSessions with custom user defaults. Should generally be called from application:DidFinishLaunching.
+ (void)logSessionWithUserDefaults:(NSUserDefaults *)userDefaults;

/// The total number of times logSession has been called for custom user defaults.
+ (NSInteger)numberOfLoggedSessionsWithUserDefaults:(NSUserDefaults *)userDefaults;

@end
