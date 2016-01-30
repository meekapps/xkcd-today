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
#import "XKCD.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
  [super viewDidLoad];

}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  //Fetch most recent persisted comic from Core Data.
  __weak TodayViewController *weakSelf = self;
  [[XKCD sharedInstance] fetchLatestComic:^(XKCDComic *fetchedComic) {
    if (fetchedComic) {
      [weakSelf updateWithComic:fetchedComic];
    }
    
    //GET latest comic from HTTP request, update UI if it is new.
    [[XKCD sharedInstance] getLatestComic:^(XKCDComic *httpComic) {
      NSLog(@"got comic: %@", httpComic);
      if (fetchedComic.index != httpComic.index) {
        [weakSelf updateWithComic:httpComic];
      }
    }];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - Private

- (void) updateWithComic:(XKCDComic*)comic {
  NSLog(@"updating with comic: %@", comic);
}

@end
