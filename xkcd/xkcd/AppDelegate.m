//
//  AppDelegate.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "AppDelegate.h"
#import "NSObject+BackgroundTask.h"
#import "PersistenceController.h"
#import "UIColor+XKCD.h"
#import "XKCD.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window.tintColor = [UIColor blackColor];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[PersistenceController sharedInstance] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[PersistenceController sharedInstance] saveContext];
}

- (void) application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
  NSLog(@"handle events from bg session");
  self.backgroundSessionCompletionHandler = completionHandler;
}

- (void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  NSLog(@"perform fetch handler");
  [self performBackgroundTaskWithBlock:^{
    [[XKCD sharedInstance] getLatestComic:^(XKCDComic *comic) {
      completionHandler(UIBackgroundFetchResultNewData);
    }];
  }];
}

@end
