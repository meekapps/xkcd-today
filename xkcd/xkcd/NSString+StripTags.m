//
//  NSString+StripTags.m
//  xkcd
//
//  Created by Mike Keller on 8/7/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "NSString+StripTags.h"

@implementation NSString (StripTags)

- (NSString*) convertParagraphTagsToNewlines {
  NSString *string = [self copy];
  
  string = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n"];
  
  return string;
}

- (NSString*) stripEdits {
  NSString *string = [self copy];
  
  string = [string stringByReplacingOccurrencesOfString:@"[edit] " withString:@""];
  
  return string;
}

- (NSString*) stripTags {
  
  NSString *string = [self copy];
  
  NSRange range;
  while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
    
    string = [string stringByReplacingCharactersInRange:range
                                             withString:@""];
  }
  return string;
}

- (NSString*) trimStringBeforeExplanation {
  NSString *string = [self copy];
  @try {
    NSRange explanationRange = [string rangeOfString:@"Explanation"];
    string = [string substringFromIndex:explanationRange.location];
  } @catch (NSException *exception) {
    string = nil;
  } @finally {
    return string;
  }

}

@end
