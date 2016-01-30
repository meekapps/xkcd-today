//
//  UIImage+AsyncImage.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "UIImage+AsyncImage.h"

@implementation UIImage (AsyncImage)

+ (void) imageFromUrl:(NSString*)urlString
           completion:(void(^)(UIImage *image))completion {
  
  NSURL *url = [NSURL URLWithString:urlString];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url
                                         options:kNilOptions
                                           error:&error];
    UIImage *image = nil;
    
    if (data && !error) {
      image = [UIImage imageWithData:data];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      completion(image);
    });
  });
  
}

@end
