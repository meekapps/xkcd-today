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

- (void) fetchLatestComic:(void(^)(XKCDComic *comic))completion;
- (void) getLatestComic:(void(^)(XKCDComic *comic))completion;

@end
