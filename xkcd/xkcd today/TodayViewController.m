//
//  TodayViewController.m
//  xkcd today
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Meek Apps. All rights reserved.
//

#import "TodayViewController.h"
#import "PersistenceManager.h"
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
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadLatestWithCompletion:^(NCUpdateResult updateResult) {}];
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

- (void) loadLatestWithCompletion:(void(^)(NCUpdateResult updateResult))completion {
  self.titleLabel.text = nil;
  
  //Fetch most recent persisted comic from Core Data.
  __weak TodayViewController *weakSelf = self;
  XKCDComic *fetchedComic = [[XKCD sharedInstance] fetchLatestComic];
    
  if (fetchedComic) {
    [weakSelf updateViewsWithComic:fetchedComic];
  }
  
  //GET latest comic from HTTP request, update UI if it is new.
  [[XKCD sharedInstance] getLatestComic:^(XKCDComic *httpComic) {
    NCUpdateResult updateResult = NCUpdateResultFailed;
    
    if (![fetchedComic.index equals:httpComic.index]) {
      [weakSelf updateViewsWithComic:httpComic];
      updateResult = NCUpdateResultNewData;
    }
    
    completion(updateResult);
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
      [self updatePreferredSize];
      return;
    }
  }
  
  //Image
  __weak TodayViewController *weakSelf = self;
  [comic getImage:^(UIImage * _Nonnull image) {
    weakSelf.imageView.image = image;
    [weakSelf updatePreferredSize];
  }];
}

- (void) updatePreferredSize {
  CGFloat height = MAX(200.0F, self.imageView.bounds.size.height);
  self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, height);
}

@end
