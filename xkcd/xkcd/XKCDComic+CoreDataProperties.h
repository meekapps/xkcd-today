//
//  XKCDComic+CoreDataProperties.h
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 meek apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "XKCDComic.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKCDComic (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSNumber *index;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *favorite;

@end

NS_ASSUME_NONNULL_END
