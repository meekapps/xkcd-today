//
//  TodayViewManager.h
//  xkcd
//
//  Created by Mike Keller on 2/10/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "LaunchManager.h"

@interface TodayViewManager : LaunchManager <LaunchHandling>

+ (instancetype) sharedManager;

@end
