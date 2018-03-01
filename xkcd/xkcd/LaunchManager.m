//
//  LaunchHelper.h
//  xkcd
//
//  Created by Mike Keller on 11/27/15.
//  Copyright © 2016 Meek Apps. All rights reserved.
//
//  LaunchHandling: a protocol that a LaunchHelper subclass should conform to. A class conforming to LaunchHandling
//  is contracted to process a launchObject (any object that can be passed in the launchOptions dictionary in
//  application:didFinishLaunchWithOptions, e.g. NSUserActivity, UIApplicationShortcutItem) and return an
//  index
//
//  LaunchHelper: a superclass that a LaunchHandling class should extend. A LaunchHelper subclass gains the
//  ability to handle a launchObject (defined above) in a generic way. Calling handleLaunchObject on a subclass
//  resets the window and posts a ShowComic notification with userInfo containing the index
//  dealt by the protocol. Any specific soft-launch application delegate methods (e.g.
//  application:continueUserActivity:restorationHandler:) should call handleLaunchObject on its corresponding
//  LaunchHelper subclass.

#import "LaunchManager.h"

NSString *const kIndexKey = @"index";
NSString *const ShowComicNotification = @"ShowComicNotification";

@implementation LaunchManager

#pragma mark - LaunchHandling

// Default implementation returns nil.
- (id) launchObjectFromLaunchOptions:(NSDictionary*)launchOptions {
  return nil;
}

// Default implementation returns nil.
- (NSNumber*) indexWithLaunchObject:(id)launchObject {
  return nil;
}

#pragma mark - LaunchHelper

// Acquires launchObject from protocol, then calls handleLaunchObject.
- (BOOL) handleLaunchOptions:(NSDictionary*)launchOptions {
  
  id launchObject = [self launchObjectFromLaunchOptions:launchOptions];
  
  return [self handleLaunchObject:launchObject];
}

// Default implementation acquires comic index from protocol and posts notification.
- (BOOL) handleLaunchObject:(id)launchObject {
  
  NSNumber *index = [self indexWithLaunchObject:launchObject];
  if (!index) return NO;
    
  NSDictionary *userInfo = index ? @{kIndexKey : index} : nil;
  NSNotification *notification = [NSNotification notificationWithName:ShowComicNotification
                                                               object:nil
                                                             userInfo:userInfo];
  
  if (!notification) return NO;
  
  [[NSNotificationCenter defaultCenter] postNotification:notification];
  
  return YES;
}

@end
