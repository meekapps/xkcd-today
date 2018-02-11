//
//  XKCDComic.h
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

@import CoreData;
@import Foundation;
@import UIKit;

@interface XKCDComic : NSManagedObject

/// Fetch the image from Core Data, if available; over HTTP if only the URL is cached.
- (void) getImage:(void(^)(UIImage *image))completion;

@end

#import "XKCDComic+CoreDataProperties.h"
