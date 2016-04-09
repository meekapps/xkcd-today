//
//  NSString+XKCDImageUrl.m
//  xkcd
//
//  Created by Mike Keller on 4/9/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "NSString+XKCDImageUrl.h"

@implementation NSString (XKCDImageUrl)

- (BOOL) isValidImageUrl {
  if (self.length < 12) return NO; //at least as long as http + filename + suffix http://a.png
  
  //check for presence of image suffix
  if ([self rangeOfString:@".gif"].location == NSNotFound &&
      [self rangeOfString:@".jpeg"].location == NSNotFound &&
      [self rangeOfString:@".jpg"].location == NSNotFound &&
      [self rangeOfString:@".png"].location == NSNotFound) {
    return NO;
  };
  
  return YES;
}

@end
