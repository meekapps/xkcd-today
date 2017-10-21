//
//  NSString+XKCDImageUrl.h
//  xkcd
//
//  Created by Mike Keller on 4/9/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

@import Foundation;

@interface NSString (XKCDImageUrl)

/// Simple imageUrl validation just checks for string length and presence of valid image format suffix.
- (BOOL) isValidImageUrl;

@end
