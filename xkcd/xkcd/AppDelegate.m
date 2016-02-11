//
//  AppDelegate.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "AppDelegate.h"
#import "PersistenceManager.h"
#import "ShortcutsManager.h"
#import "SpotlightManager.h"
#import "TodayViewManager.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window.tintColor = [UIColor blackColor];
  
  if (![[ShortcutsManager sharedManager] handleLaunchOptions:launchOptions]) {
    if (![[SpotlightManager sharedManager] handleLaunchOptions:launchOptions]) {
      [[TodayViewManager sharedManager] handleLaunchOptions:launchOptions];
    }
  }
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[PersistenceManager sharedManager] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[PersistenceManager sharedManager] saveContext];
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray *))restorationHandler {
  return [[SpotlightManager sharedManager] handleLaunchObject:userActivity];
}

- (void) application:(UIApplication *)application
performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem
   completionHandler:(nonnull void (^)(BOOL))completionHandler {
  completionHandler([[ShortcutsManager sharedManager] handleLaunchObject:shortcutItem]);
}

- (BOOL) application:(UIApplication *)app
             openURL:(NSURL *)url
             options:(NSDictionary<NSString *,id> *)options {
  return [[TodayViewManager sharedManager] handleLaunchObject:url];
}

@end
