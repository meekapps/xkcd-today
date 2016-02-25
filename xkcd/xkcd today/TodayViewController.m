//
//  TodayViewController.m
//  xkcd today
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Meek Apps. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "NSDate+ShortDate.h"
#import <NotificationCenter/NotificationCenter.h>
#import "NSNumber+Operations.h"
#import "PersistenceManager.h"
#import "TodayViewController.h"
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
  
  //Fetch most recent persisted comic from Core Data.
  __weak TodayViewController *weakSelf = self;
  XKCDComic *fetchedComic = [[XKCD sharedInstance] fetchComicWithIndex:nil];
  
  if (fetchedComic) {
    self.currentComic = fetchedComic;
    [weakSelf updateViewsWithComic:fetchedComic];
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  self.currentComic = nil;
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
  
  //GET latest comic from HTTP request, update UI if it is new.
  __weak TodayViewController *weakSelf = self;
  [[XKCD sharedInstance] getComicWithIndex:nil
                                completion:^(XKCDComic *httpComic) {
                                  
                                  //no comic, fail
                                  if (!httpComic) {
                                    completion(NCUpdateResultFailed);
                                    return;
                                  }
                                  
                                  //new comic
                                  if (![weakSelf.currentComic.index equals:httpComic.index]) {
                                    weakSelf.currentComic = httpComic;
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
      [self updateContentHeight];
      return;
    }
  }
  
  //Image
  __weak TodayViewController *weakSelf = self;
  
  [comic getImage:^(UIImage * _Nonnull image) {
    weakSelf.imageView.image = image;
    [weakSelf updateContentHeight];
  }];
}

- (void) updateContentHeight {
  CGFloat kMaxHeight = 300.0F;
  CGRect boundingRect = CGRectMake(0.0F, 0.0F, self.view.bounds.size.width, kMaxHeight);
  CGRect contentFrame = AVMakeRectWithAspectRatioInsideRect(self.imageView.image.size, boundingRect);
  contentFrame.size.height += self.imageView.frame.origin.y + self.view.layoutMargins.bottom;
  self.preferredContentSize = contentFrame.size;
  
  NSLog(@"image height: %f, bounding height: %f, content height: %f", self.imageView.image.size.height,  boundingRect.size.height, contentFrame.size.height);
}

@end
