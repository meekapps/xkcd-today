//
//  XKCDAlertController.h
//  xkcd
//
//  Created by Mike Keller on 4/9/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKCDComic.h"

@interface XKCDAlertController : UIAlertController

+ (instancetype) blacklistAlertControllerWithComic:(XKCDComic*)comic;

+ (instancetype) imageErrorAlertControllerWithComic:(XKCDComic*)comic;

@end
