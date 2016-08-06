//
//  XKCDExplained.h
//  xkcd
//
//  Created by Mike Keller on 8/4/16.
//  Copyright © 2016 Perka. All rights reserved.
//

@class XKCDComic;

#import <Foundation/Foundation.h>

@interface XKCDExplained : NSObject

+ (void) explain:(XKCDComic*)comic;

@end
