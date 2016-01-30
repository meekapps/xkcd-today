//
//  NSObject+BackgroundTask.h
//  Meek Apps
//
//  Created by Mike Keller on 11/20/14.
//  Copyright (c) 2014 Perka. All rights reserved.
//
//  Perform a generic background task block.

#import <Foundation/Foundation.h>

@interface NSObject (BackgroundTask)

- (void)performBackgroundTaskWithBlock:(void(^)(void))block;

@end
