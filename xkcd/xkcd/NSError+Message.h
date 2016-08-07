//
//  NSError+Message.h
//  xkcd
//
//  Created by Mike Keller on 8/7/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Message)

+ (NSError*) errorWithDomain:(NSString*)domain
                        code:(NSInteger)code
                     message:(NSString*)message;

@end
