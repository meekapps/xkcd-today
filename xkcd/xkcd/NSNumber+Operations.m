//
//  NSNumber+Operations.m
//  xkcd
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "NSNumber+Operations.h"

@implementation NSNumber (Operations)

- (NSNumber*) add:(NSInteger)integer {
  return @(self.integerValue + integer);
}

- (BOOL) equals:(NSNumber*)number {
  NSComparisonResult result = [self compare:number];
  BOOL equal = result == NSOrderedSame;
  return equal;
}

- (BOOL) greaterThan:(NSNumber*)number {
  NSComparisonResult result = [self compare:number];
  BOOL greater = result == NSOrderedAscending;
  return greater;
}

- (BOOL) lessThan:(NSNumber*)number {
  NSComparisonResult result = [self compare:number];
  BOOL less = result == NSOrderedDescending;
  return less;
}

- (NSNumber*) subtract:(NSInteger)integer {
  return @(self.integerValue - integer);
}

+ (NSNumber*) randomWithMinimum:(NSNumber*)minimum
                        maximum:(NSNumber*)maximum {
  int minInt = (int)minimum.integerValue;
  int maxInt = (int)maximum.integerValue;
  int random = arc4random_uniform(maxInt);
  int boundedRandom = minInt + random;
  return @(boundedRandom);
}

@end
