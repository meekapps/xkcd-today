//
//  NSDate+ShortDate.m
//  xkcd
//
//  Created by Mike Keller on 2/10/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "NSDate+ShortDate.h"

@implementation NSDate (ShortDate)

- (NSString*) shortDate {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateStyle = NSDateFormatterShortStyle;
  dateFormatter.timeStyle = NSDateFormatterNoStyle;
  return [dateFormatter stringFromDate:self];
}

@end
