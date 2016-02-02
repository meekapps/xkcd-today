//
//  AppDelegate.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "AppDelegate.h"
#import "SpotlightManager.h"
#import "PersistenceManager.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window.tintColor = [UIColor blackColor];
  
  [[SpotlightManager sharedManager] handleLaunchOptions:launchOptions];
  
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

@end
