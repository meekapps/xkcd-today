//
//  UIImage+AsyncImage.h
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AsyncImage)

+ (void) imageFromUrl:(NSString*)urlString
           completion:(void(^)(UIImage *image))completion;

@end
