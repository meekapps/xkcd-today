//
//  XKCD.h
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKCDComic.h"

FOUNDATION_EXPORT NSString *const kXKCDServerBase;

typedef void(^XKCDComicCompletion)(XKCDComic *comic);

@interface XKCD : NSObject <NSURLSessionDelegate>

@property (strong, readonly, nonatomic) NSNumber *latestComicIndex;


+ (instancetype) sharedInstance;

/// Returns YES if index cannot be loaded natively.
- (BOOL) comicIsBlacklisted:(NSNumber*)index;

/// Adjusts favorite indices
- (void) moveFavoriteFromIndex:(NSUInteger)fromIndex
                       toIndex:(NSUInteger)toIndex;

/// Adds or removes comic to/from favorites.
- (void) toggleFavorite:(NSNumber*)index;

/// Fetches favorites.
- (NSArray<XKCDComic*>*) fetchFavorites;

/// Fetches latest (highest index) comic from Core Data.
- (XKCDComic*) fetchLatestComic;

/// Fetches comic from with index from Core Data. Passing index=nil fetches latest (highest index) comic.
- (XKCDComic*) fetchComicWithIndex:(NSNumber*)index;

/// GETs latest comic from an HTTP request.
- (void) getLatestComic:(XKCDComicCompletion)completion;

/// GETs comic with index from an HTTP request. Passing index=nil gets latest comic.
- (void) getComicWithIndex:(NSNumber*)index
                completion:(XKCDComicCompletion)completion;

@end
