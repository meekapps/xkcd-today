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

+ (NSInteger) numberOfLoggedSessions {
  return [NSUserDefaults.standardUserDefaults integerForKey:kNumberOfSessionsKey];
}

+ (void) logSession {
  NSUInteger numberOfSessions = [self numberOfLoggedSessions] + 1;
  NSUserDefaults *userDefaults = NSUserDefaults.standardUserDefaults;
  [userDefaults setInteger:numberOfSessions forKey:kNumberOfSessionsKey];
  [userDefaults synchronize];
}

@end
