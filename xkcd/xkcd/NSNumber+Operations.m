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

- (NSNumber*) subtract:(NSInteger)integer {
  return @(self.integerValue - integer);
}

@end
