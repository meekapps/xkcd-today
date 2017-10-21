//
//  NSString+XKCDImageUrl.m
//  xkcd
//
//  Created by Mike Keller on 4/9/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "NSString+XKCDImageUrl.h"

@implementation NSString (XKCDImageUrl)

- (BOOL) isValidImageUrl {
  if (self.length < 12) return NO; //at least as long as http + filename + suffix http://a.png
  
  BOOL isValid = YES;
  //check for presence of image suffix
  @try {
    if ([self rangeOfString:@".gif"].location == NSNotFound &&
        [self rangeOfString:@".jpeg"].location == NSNotFound &&
        [self rangeOfString:@".jpg"].location == NSNotFound &&
        [self rangeOfString:@".png"].location == NSNotFound) {
      isValid = NO;
    };
  } @catch (NSException *exception) {
    NSLog(@"Exception was caught checking url string: %@", exception);
    isValid = NO;
  } @finally {
    return isValid;
  }
}

@end
