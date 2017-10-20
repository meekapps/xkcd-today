//
//  ShareController.h
//  xkcd
//
//  Created by Mike Keller on 2/21/16.
//  Copyright © 2016 Perka. All rights reserved.
//
//  Default UIActivityController used for sharing an XKCDComic.

@import UIKit;

@class XKCDComic;

@interface ShareController : UIActivityViewController

- (instancetype) initWithComic:(XKCDComic*)comic;

@end
