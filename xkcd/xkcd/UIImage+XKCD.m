//
//  UIImage+XKCD.m
//  xkcd
//
//  Created by Mike Keller on 2/4/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "UIImage+XKCD.h"

@implementation UIImage (XKCD)

+ (UIImage*) heartImage:(BOOL)filled {
  return filled ? [UIImage imageNamed:@"heart-filled"] : [UIImage imageNamed:@"heart-outline"];
}

@end
