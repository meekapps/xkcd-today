//
//  ShortcutsManager.h
//  xkcd
//
//  Created by Mike Keller on 2/2/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "LaunchManager.h"

@interface ShortcutsManager : LaunchManager <LaunchHandling>

+ (instancetype) sharedManager;

@end
