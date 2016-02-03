//
//  ShortcutsManager.m
//  xkcd
//
//  Created by Mike Keller on 2/2/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "NSNumber+Operations.h"
#import "ShortcutsManager.h"
#import <UIKit/UIKit.h>
#import "XKCD.h"

static NSString *const kShortcutTypeLatest = @"latest";
static NSString *const kShortcutTypeRandom = @"random";

@implementation ShortcutsManager

+ (instancetype) sharedManager {
  static dispatch_once_t onceToken;
  static ShortcutsManager *instance = nil;
  dispatch_once(&onceToken, ^{
    instance = [[ShortcutsManager alloc] init];
  });
  return instance;
}

#pragma mark - LaunchHandling

- (id) launchObjectFromLaunchOptions:(NSDictionary *)launchOptions {
  
  //The launchOptions dictionary may contain a UIApplicationShortcutItem object,
  //which can be obtained with the UIApplicationLaunchOptionsShortcutItemKey key
  UIApplicationShortcutItem *shortcutItem = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
  if (!shortcutItem) return nil;
  
  return shortcutItem;
}

- (NSNumber*) indexWithLaunchObject:(id)launchObject {
  if (![launchObject isKindOfClass:[UIApplicationShortcutItem class]]) return nil;
  
  UIApplicationShortcutItem *shortcutItem = (UIApplicationShortcutItem*)launchObject;
  NSString *shortcutType = shortcutItem.type;
  
  if ([shortcutType isEqualToString:kShortcutTypeLatest]) {
    return nil; //index = nil loads latest
  } else if ([shortcutType isEqualToString:kShortcutTypeRandom]) {
    NSNumber *latestIndex = [XKCD sharedInstance].latestComicIndex;
    if (!latestIndex) return nil;
    NSNumber *random = [NSNumber randomWithMinimum:@(1) maximum:latestIndex];
    return random;
  }
  
  return nil;
}

@end
