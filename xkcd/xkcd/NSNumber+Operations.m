//
//  NSNumber+Operations.m
//  xkcd
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Meek Apps. All rights reserved.
//

#import "NSNumber+Operations.h"

@implementation NSNumber (Operations)

- (NSNumber*) add:(NSInteger)integer {
  return @(self.integerValue + integer);
}

- (BOOL) equals:(NSNumber*)number {
  if (!number) return NO;
  
  NSComparisonResult result = [self compare:number];
  BOOL equal = result == NSOrderedSame;
  return equal;
}

- (BOOL) greaterThan:(NSNumber*)number {
  if (!number) return NO;
  
  NSComparisonResult result = [self compare:number];
  BOOL greater = result == NSOrderedDescending;
  return greater;
}

- (BOOL) lessThan:(NSNumber*)number {
  if (!number) return NO;
  
  NSComparisonResult result = [self compare:number];
  BOOL less = result == NSOrderedAscending;
  return less;
}

- (NSNumber*) subtract:(NSInteger)integer {
  return @(self.integerValue - integer);
}

+ (NSNumber*) randomWithMinimum:(NSNumber*)minimum
                        maximum:(NSNumber*)maximum {
  if ([minimum greaterThan:maximum]) return @0;
  
  int minInt = (int)minimum.integerValue;
  int maxInt = (int)maximum.integerValue;
  int random = arc4random_uniform(maxInt - minInt + 1);
  int boundedRandom = minInt + random;
  return @(boundedRandom);
}

@end
