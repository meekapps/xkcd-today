//
//  XKCDExplained.h
//  xkcd
//
//  Created by Mike Keller on 8/4/16.
//  Copyright © 2016 Perka. All rights reserved.
//

@class XKCDComic;

#import <Foundation/Foundation.h>

typedef void(^XKCDExplainedCompletion)(NSString *explanation, NSError *error);

@interface XKCDExplained : NSObject

/// Calls Wikimedia API. Completes with plain text of explanation.
+ (void) explain:(XKCDComic*)comic
      completion:(XKCDExplainedCompletion)completion;

/// Opens Safari to explanation.
+ (void) openExplanationInSafari:(XKCDComic*)comic;

@end
