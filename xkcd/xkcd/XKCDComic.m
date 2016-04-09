//
//  XKCDComic.m
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "NSString+XKCDImageUrl.h"
#import "PersistenceManager.h"
#import "UIImage+AsyncImage.h"
#import "XKCDComic.h"

@implementation XKCDComic

- (void) getImage:(void(^)(UIImage *image))completion {
  
  //already stored image data in Core Data
  if (self.image) {
    UIImage *image = [UIImage imageWithData:self.image];
    completion(image);
    
  //Haven't yet stored image data, fetch over http
  } else {
    NSString *urlString = self.imageUrl;
    
    //Invalid imageUrl string, happens for non-standard comics, e.g. 1663 "Garden"
    if (![urlString isValidImageUrl]) {
      completion(nil);
      return;
    }
    __weak XKCDComic *weakSelf = self;
    [UIImage imageFromUrl:urlString
               completion:^(UIImage *image) {
                 
                 if (image) {
                   //sets managed object image in context to be persisted.
                   weakSelf.image = UIImagePNGRepresentation(image);
                   [[PersistenceManager sharedManager] saveContext];
                 }
                 
                 completion(image);
               }];
  }
}

@end
