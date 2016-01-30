//
//  NSObject+BackgroundTask.m
//  Meek Apps
//
//  Created by Mike Keller on 11/20/14.
//  Copyright (c) 2014 meek apps. All rights reserved.
//
//  Perform a generic background task block.

#import "NSObject+BackgroundTask.h"
#import <UIKit/UIKit.h>

@implementation NSObject (BackgroundTask)

- (void)performBackgroundTaskWithBlock:(void(^)(void))block {
  UIApplication *application = [UIApplication sharedApplication];
  [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

  __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
  }];
  
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    block();
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
  });
}

@end
