//
//  NSDate+ShortDate.h
//  xkcd
//
//  Created by Mike Keller on 2/10/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

@import Foundation;

@interface NSDate (ShortDate)

- (NSString *) shortDate;
- (NSString *) shortDateWithTimeZone:(NSTimeZone *)timeZone;

@end
