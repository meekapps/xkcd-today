//
//  SpotlightManager.m
//  xkcd
//
//  Created by Mike Keller on 2/2/16.
//  Copyright © 2016 Meek Apps. All rights reserved.
//

#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "SpotlightManager.h"
#import "UIImage+AsyncImage.h"
#import <UIKit/UIKit.h>

@implementation SpotlightManager

+ (instancetype) sharedManager {
  static dispatch_once_t onceToken;
  static SpotlightManager *instance = nil;
  dispatch_once(&onceToken, ^{
    instance = [[SpotlightManager alloc] init];
  });
  return instance;
}

- (void) indexComic:(XKCDComic *)comic {
  if (![CSSearchableIndex isIndexingAvailable]) return;
  
  CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc]
                                              initWithItemContentType:(NSString*)kUTTypePNG];
  //Title
  if (comic.title) {
    attributes.title = comic.title;
  }
  
  //Keywords
  attributes.keywords = [self keywordsWithComic:comic];
  
  void(^finishIndexing)(void) = ^void(void) {
    NSLog(@"finish indexing");
    //Index the comic
    NSString *indexString = [NSString stringWithFormat:@"%@", @(comic.index.integerValue)];
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    CSSearchableItem *searchableItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:indexString
                                                                         domainIdentifier:bundleId
                                                                             attributeSet:attributes];
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[searchableItem]
                                                   completionHandler:^(NSError * _Nullable error) {
                                                     if (error) {
                                                       NSLog(@"failed to index comic: %@, error: %@", comic, error);
                                                     }
                                                   }];
  };
  
  //Image
  if (comic.image) {
    attributes.thumbnailData = comic.image;
    finishIndexing();
    
  } else if (comic.imageUrl) {
    //wait for image download to finish index
    NSLog(@"download image thumbnail");
    [UIImage imageFromUrl:comic.imageUrl
               completion:^(UIImage *image) {
                 attributes.thumbnailData = UIImagePNGRepresentation(image);
                 finishIndexing();
               }];
  }

  
  
}

#pragma mark - LaunchingHandling

- (NSNumber*) indexWithLaunchObject:(id)launchObject {
  if (![launchObject isKindOfClass:[NSUserActivity class]]) return nil;
  
  NSUserActivity *userActivity = (NSUserActivity*)launchObject;
  
  if (![userActivity.activityType isEqualToString:CSSearchableItemActionType]) return nil;
  
  NSString *index = userActivity.userInfo[CSSearchableItemActivityIdentifier];
  NSNumber *indexNumber = @(index.integerValue);
  
  return index ? indexNumber : nil;
}

- (id) launchObjectFromLaunchOptions:(NSDictionary *)launchOptions {
  
  NSDictionary *userActivityDictionary = launchOptions[UIApplicationLaunchOptionsUserActivityDictionaryKey];
  if (!userActivityDictionary) return nil;
  
  //The UIApplicationLaunchOptionsUserActivityDictionaryKey dictionary does not contain a public key to access
  //the NSUserActivity object, but it can obtained by enumeration.
  __block NSUserActivity *userActivity = nil;
  [userActivityDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    
    if ([obj isKindOfClass:[NSUserActivity class]]) {
      userActivity = (NSUserActivity*)obj;
      *stop = YES;
    }
  }];
  return userActivity;
}

#pragma mark - Private

//Returns keywords, which consists of a default set and the comic title components.
- (NSArray*) keywordsWithComic:(XKCDComic*)comic {
  NSArray *keywords = @[@"xkcd", @"webcomic", @"comic", @"romance", @"sarcasm", @"math", @"language"];
  NSArray *titleComponents = [comic.title componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  keywords = [keywords arrayByAddingObjectsFromArray:titleComponents];
  return keywords;
}

@end
