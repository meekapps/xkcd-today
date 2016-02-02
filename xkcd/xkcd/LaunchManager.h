//
//  LaunchManager.h
//  Meek Apps
//
//  Created by Mike Keller on 11/27/15.
//  Copyright © 2015 Perka. All rights reserved.
//
//  LaunchHandling: a protocol that a LaunchHelper subclass should conform to. A class conforming to LaunchHandling
//  is contracted to process a launchObject (any object that can be passed in the launchOptions dictionary in
//  application:didFinishLaunchWithOptions, e.g. NSUserActivity, UIApplicationShortcutItem) and return a
//  merchantLocationUuid.
//
//  LaunchHelper: a superclass that a LaunchHandling class should extend. A LaunchHelper subclass gains the
//  ability to handle a launchObject (defined above) in a generic way. Calling handleLaunchObject on a subclass
//  resets the window and posts a ShowMerchantView notification with userInfo containing the merchantLocationUuid
//  dealt by the protocol. Any specific soft-launch application delegate methods (e.g.
//  application:continueUserActivity:restorationHandler:) should call handleLaunchObject on its corresponding
//  LaunchHelper subclass.

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kIndexKey;
FOUNDATION_EXPORT NSString *const ShowComicNotification;

#pragma mark - LaunchHandling

@protocol LaunchHandling <NSObject>

@required
/// Extract a launch object from the application:didFinishLaunchingWithoptions launchOptions dictionary.
- (id) launchObjectFromLaunchOptions:(NSDictionary*)launchOptions;

/// Extract an index from a launch object.
- (NSNumber*) indexWithLaunchObject:(id)launchObject;

@end

#pragma mark - LaunchHelper

@interface LaunchManager : NSObject

/** A LaunchHelper subclasses inherits this to be called from application:didFinishLaunchWithOptions. */
- (BOOL) handleLaunchOptions:(NSDictionary*)launchOptions;

/** A LaunchHelper subclass inherits this to be called from its corresponding UIApplicationDelegate method. 
  * A launchObject is any object that may be a part of the application:didFinishLaunchingWithOptions launchOptions 
  * dictionary (e.g. NSUserActivity). 
  * The default implementation acquires an index from the protocol method and posts ShowComic
  * notification.
  * @returns YES if the launchObject could be handled.
 */
- (BOOL) handleLaunchObject:(id)launchObject;

@end
