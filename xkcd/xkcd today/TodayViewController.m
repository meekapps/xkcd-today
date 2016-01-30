//
//  TodayViewController.m
//  xkcd today
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "TodayViewController.h"
#import "PersistenceController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NSNumber+Operations.h"
#import "UIImage+AsyncImage.h"
#import "XKCD.h"

static NSString *const kContainerAppUrlScheme = @"xkcd-today://";

@interface TodayViewController () <NCWidgetProviding>
@end

#pragma mark - Lifecycle

@implementation TodayViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self initialLoad];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)tappedView:(id)sender {
  NSURL *containerAppUrl = [NSURL URLWithString:kContainerAppUrlScheme];
  [self.extensionContext openURL:containerAppUrl completionHandler:^(BOOL success) {}];
}

#pragma mark - Private

- (void) initialLoad {
  self.titleLabel.text = @"Loading";
  //Fetch most recent persisted comic from Core Data.
  __weak TodayViewController *weakSelf = self;
  [[XKCD sharedInstance] fetchLatestComic:^(XKCDComic *fetchedComic) {
    if (fetchedComic) {
      [weakSelf updateViewsWithComic:fetchedComic];
    }
    
    //GET latest comic from HTTP request, update UI if it is new.
    [[XKCD sharedInstance] getLatestComic:^(XKCDComic *httpComic) {
      if (![fetchedComic.index equals:httpComic.index]) {
        [weakSelf updateViewsWithComic:httpComic];
      }
    }];
  }];
}

- (void) updateViewsWithComic:(XKCDComic*)comic {
  
  //Title
  NSString *title = comic.title;
  if (title) {
    self.titleLabel.text = title;
  }
  
  //Image
  NSData *cachedImageData = comic.image;
  if (cachedImageData) {
    UIImage *cachedImage = [UIImage imageWithData:cachedImageData];
    if (cachedImage) {
      self.imageView.image = cachedImage;
      return;
    }
  }
  
  //Image URL
  NSString *imageUrl = comic.imageUrl;
  if (!imageUrl) return;
  
  __weak TodayViewController *weakSelf = self;
  [UIImage imageFromUrl:imageUrl
             completion:^(UIImage *image) {
               
               if (image) {
                 //updates UI
                 weakSelf.imageView.image = image;
                 
                 //sets managed object image in context to be persisted.
                 comic.image = UIImagePNGRepresentation(image);
                 [[PersistenceController sharedInstance] saveContext];
               }
             }];
}

@end
