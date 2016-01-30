//
//  XKCD.h
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKCDComic.h"

@interface XKCD : NSObject <NSURLSessionDelegate>

+ (instancetype) sharedInstance;

/// Fetches the most recent comic from Core Data.
- (void) fetchLatestComic:(void(^)(XKCDComic *comic))completion;

/// GETs the most recent comic from an HTTP request.
- (void) getLatestComic:(void(^)(XKCDComic *comic))completion;

@end
