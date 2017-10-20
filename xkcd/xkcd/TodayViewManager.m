//
//  TodayViewManager.m
//  xkcd
//
//  Created by Mike Keller on 2/10/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "TodayViewManager.h"
@import UIKit;

static NSString *const kAppUrlScheme = @"xkcd-today://";

@implementation TodayViewManager

+ (instancetype) sharedManager {
  static dispatch_once_t onceToken;
  static TodayViewManager *instance = nil;
  dispatch_once(&onceToken, ^{
    instance = [[TodayViewManager alloc] init];
  });
  return instance;
}

#pragma mark - LaunchingHandling

- (NSNumber*) indexWithLaunchObject:(id)launchObject {
  if (![launchObject isKindOfClass:[NSURL class]]) return nil;
  
  NSURL *url = (NSURL*)launchObject;
  NSString *indexString = url.host;
  
  NSNumber *indexNumber = @(indexString.integerValue);
  
  return indexNumber ? indexNumber : nil;
}

- (id) launchObjectFromLaunchOptions:(NSDictionary *)launchOptions {
  NSURL *url = launchOptions[UIApplicationLaunchOptionsURLKey];
  return url;
}

@end
