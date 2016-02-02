//
//  NSNumber+Operations.h
//  xkcd
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Meek Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Operations)

- (NSNumber*) add:(NSInteger)integer;
- (BOOL) equals:(NSNumber*)number;
- (BOOL) greaterThan:(NSNumber*)number;
- (BOOL) lessThan:(NSNumber*)number;
- (NSNumber*) subtract:(NSInteger)integer;
+ (NSNumber*) randomWithMinimum:(NSNumber*)minimum
                        maximum:(NSNumber*)maximum;

@end
