//
//  NSError+Message.m
//  xkcd
//
//  Created by Mike Keller on 8/7/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "NSError+Message.h"

@implementation NSError (Message)

+ (NSError*) errorWithDomain:(NSString*)domain
                        code:(NSInteger)code
                     message:(NSString*)message {
  
  NSDictionary *userInfo = @{@"error": message};
  
  NSError *error = [NSError errorWithDomain:domain
                                       code:code
                                   userInfo:userInfo];
  return error;
}

@end
