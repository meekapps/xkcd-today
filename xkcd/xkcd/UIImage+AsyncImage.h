//
//  UIImage+AsyncImage.h
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

@import UIKit;

@interface UIImage (AsyncImage)

+ (void) imageFromUrl:(NSString*)urlString
           completion:(void(^)(UIImage *image))completion;

@end
