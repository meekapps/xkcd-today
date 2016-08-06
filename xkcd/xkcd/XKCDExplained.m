//
//  XKCDExplained.m
//  xkcd
//
//  Created by Mike Keller on 8/4/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "XKCDExplained.h"
#import "XKCDComic.h"

static NSString *const kExplainUrl = @"http://www.explainxkcd.com/wiki/index.php";

@implementation XKCDExplained

+ (void) explain:(XKCDComic*)comic {
  NSNumber *comicIndex = comic.index;
  NSString *explainUrl = [NSString stringWithFormat:@"%@/%@", kExplainUrl, comicIndex];
  NSURL *url = [NSURL URLWithString:explainUrl];
  [[UIApplication sharedApplication] openURL:url];
}

@end
