//
//  NSString+StripTags.m
//  xkcd
//
//  Created by Mike Keller on 8/7/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "NSString+StripTags.h"

@implementation NSString (StripTags)

-(NSString*) stripTags {
  
  NSString *string = [self copy];
  NSRange range;
  while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
    
    string = [string stringByReplacingCharactersInRange:range
                                             withString:@""];
  }
  return string;
}

@end
