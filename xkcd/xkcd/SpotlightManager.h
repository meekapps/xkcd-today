//
//  SpotlightManager.h
//  xkcd
//
//  Created by Mike Keller on 2/2/16.
//  Copyright © 2016 Meek Apps. All rights reserved.
//
//  

#import "LaunchManager.h"
#import "XKCDComic.h"

@interface SpotlightManager : LaunchManager <LaunchHandling>

+ (instancetype) sharedManager;

- (void) indexComic:(XKCDComic*)comic;

@end
