//
//  ShareController.h
//  xkcd
//
//  Created by Mike Keller on 2/21/16.
//  Copyright © 2016 meek apps. All rights reserved.
//
//  Default UIActivityController used for sharing an XKCDComic.

@import UIKit;

@class XKCDComic;

@interface ShareController : UIActivityViewController

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray<__kindof UIActivity *> *)applicationActivities NS_UNAVAILABLE;

- (instancetype)initWithComic:(XKCDComic*)comic;

@end
