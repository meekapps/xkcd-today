//
//  PersistenceController.h
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//
//  Sets up and provides common access to Core Data.
//  Single context stack.

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface PersistenceManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype) sharedManager;

- (void)saveContext;

@end
