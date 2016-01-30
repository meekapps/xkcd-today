//
//  PersistenceController.h
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface PersistenceController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype) sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
