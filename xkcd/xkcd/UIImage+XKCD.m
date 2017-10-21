//
//  UIImage+XKCD.m
//  xkcd
//
//  Created by Mike Keller on 2/4/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "UIImage+XKCD.h"

@implementation UIImage (XKCD)

+ (UIImage*) heartImageFilled:(BOOL)filled
                    landscape:(BOOL)landscape {
  
  if (landscape) {
    return filled ? [UIImage imageNamed:@"heart-filled-landscape"] : [UIImage imageNamed:@"heart-outline-landscape"];
  } else {
    return filled ? [UIImage imageNamed:@"heart-filled"] : [UIImage imageNamed:@"heart-outline"];
  }
}

@end
