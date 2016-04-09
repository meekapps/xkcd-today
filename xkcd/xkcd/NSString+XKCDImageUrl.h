//
//  NSString+XKCDImageUrl.h
//  xkcd
//
//  Created by Mike Keller on 4/9/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XKCDImageUrl)

/// Simple imageUrl validation just checks for string length and presence of valid image format suffix.
- (BOOL) isValidImageUrl;

@end
