//
//  TodayViewController.m
//  xkcd today
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Meek Apps. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TodayViewController.h"
#import "PersistenceManager.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NSNumber+Operations.h"
#import "UIImage+AsyncImage.h"
#import "XKCD.h"

static NSString *const kContainerAppUrlScheme = @"xkcd-today://";

@interface TodayViewController () <NCWidgetProviding>
@property (strong, nonatomic) XKCDComic *currentComic;
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

- (void) widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
  [self loadLatestWithCompletion:^(NCUpdateResult updateResult) {
    completionHandler(updateResult);
  }];
}

#pragma mark - Actions

- (IBAction)tappedView:(id)sender {
  //e.g. xkcd-today://1636
  NSString *urlString = self.currentComic.index ?
  [NSString stringWithFormat:@"%@%@", kContainerAppUrlScheme, self.currentComic.index]
  : kContainerAppUrlScheme;
  
  NSURL *containerAppUrl = [NSURL URLWithString:urlString];
  [self.extensionContext openURL:containerAppUrl
               completionHandler:^(BOOL success) {}];
}

#pragma mark - Private

- (void) loadLatestWithCompletion:(void(^)(NCUpdateResult updateResult))completion {
  self.titleLabel.text = nil;
  
  //Fetch most recent persisted comic from Core Data.
  __weak TodayViewController *weakSelf = self;
  XKCDComic *fetchedComic = [[XKCD sharedInstance] fetchComicWithIndex:nil];
    
  if (fetchedComic) {
    self.currentComic = fetchedComic;
    [weakSelf updateViewsWithComic:fetchedComic];
  }
  
  //GET latest comic from HTTP request, update UI if it is new.
  [[XKCD sharedInstance] getComicWithIndex:nil
                                completion:^(XKCDComic *httpComic) {
                                  
                                  //no comic, fail
                                  if (!httpComic) {
                                    completion(NCUpdateResultFailed);
                                    return;
                                  }
                                  
                                  //new comic
                                  if (![fetchedComic.index equals:httpComic.index]) {
                                    [weakSelf updateViewsWithComic:httpComic];
                                    completion(NCUpdateResultNewData);
                                    
                                  } else {
                                    completion(NCUpdateResultNoData);
                                  }
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
  
  //Image
  __weak TodayViewController *weakSelf = self;
  
  [comic getImage:^(UIImage * _Nonnull image) {
    weakSelf.imageView.image = image;
  }];
}

@end
