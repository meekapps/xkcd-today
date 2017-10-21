//
//  ShareController.m
//  xkcd
//
//  Created by Mike Keller on 2/21/16.
//  Copyright © 2016 meek apps. All rights reserved.
//
//  Default UIActivityController used for sharing an XKCDComic.

#import "ShareController.h"
#import "XKCDComic.h"

static NSString *const kAppStoreLink = @"https://itunes.apple.com/us/app/xkcd-today/id1082226820?ls=1&mt=8";

@interface ShareController ()
@end

@implementation ShareController

- (instancetype) initWithComic:(XKCDComic*)comic {
  
  NSMutableArray *mutableItems = [NSMutableArray array];
  
  //title
  NSString *title = comic.title;
  if (title) {
    NSString *text = [NSString stringWithFormat:@"xkcd - %@\n\n%@", title, kAppStoreLink];
    [mutableItems addObject:text];
  }
  
  //image
  NSData *imageData = comic.image;
  if (!imageData) return nil;
  UIImage *image = [UIImage imageWithData:imageData];
  [mutableItems addObject:image];
  
  NSArray *items = [mutableItems copy];
  
  self = [super initWithActivityItems:items
                applicationActivities:nil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
