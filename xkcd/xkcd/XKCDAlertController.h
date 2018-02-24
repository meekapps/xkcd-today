//
//  XKCDAlertController.h
//  xkcd
//
//  Created by Mike Keller on 4/9/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

@import UIKit;

@class XKCDComic;

@interface XKCDAlertController : UIAlertController

+ (instancetype) blacklistAlertControllerWithComic:(XKCDComic*)comic;

+ (instancetype) imageErrorAlertControllerWithComic:(XKCDComic*)comic;

@end
