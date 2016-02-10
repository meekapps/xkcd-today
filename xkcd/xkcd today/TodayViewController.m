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
static CGFloat const kMaxHeight = 360.0F;

@interface TodayViewController () <NCWidgetProviding>
@end

#pragma mark - Lifecycle

@implementation TodayViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
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
  XKCDComic *fetchedComic = [[XKCD sharedInstance] fetchComicWithIndex:nil];
    
  if (fetchedComic) {
    [weakSelf updateViewsWithComic:fetchedComic];
  }
  
  //GET latest comic from HTTP request, update UI if it is new.
  [[XKCD sharedInstance] getComicWithIndex:nil
                                completion:^(XKCDComic *httpComic) {
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
  //Use scaled content size for preferredContentSize. Theoretically this should "just work" without
  // doing this. But it don't.
  CGRect imageRect = AVMakeRectWithAspectRatioInsideRect(self.imageView.image.size,
                                                         CGRectMake(0.0F,
                                                                    0.0F,
                                                                    self.imageView.bounds.size.width,
                                                                    kMaxHeight));
  imageRect.size.height += self.imageView.frame.origin.y;
  self.preferredContentSize = imageRect.size;
}

@end
