//
//  UIApplication+Sessions.m
//  xkcd
//
//  Created by Mike Keller on 10/21/17.
//  Copyright © 2017 meek apps. All rights reserved.
//

#import "UIApplication+Sessions.h"

static NSString *const kNumberOfSessionsKey = @"numberOfSessions";

@implementation UIApplication (Sessions)

+ (NSInteger)numberOfLoggedSessions {
    NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
    return [self numberOfLoggedSessionsWithUserDefaults:userDefaults];
}

+ (void)logSession {
    NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
    [self logSessionWithUserDefaults:userDefaults];
}

+ (void)logSessionWithUserDefaults:(NSUserDefaults *)userDefaults {
    NSUInteger numberOfSessions = [self numberOfLoggedSessionsWithUserDefaults:userDefaults] + 1;
    [userDefaults setInteger:numberOfSessions forKey:kNumberOfSessionsKey];
    [userDefaults synchronize];
}

+ (NSInteger)numberOfLoggedSessionsWithUserDefaults:(NSUserDefaults *)userDefaults {
    return [userDefaults integerForKey:kNumberOfSessionsKey];
}

@end
