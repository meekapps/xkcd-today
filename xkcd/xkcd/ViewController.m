//
//  ViewController.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "PersistenceController.h"
#import "ViewController.h"
#import "UIImage+AsyncImage.h"
#import "XKCD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  __weak ViewController *weakSelf = self;
  [[XKCD sharedInstance] fetchLatestComic:^(XKCDComic *comic) {
    [weakSelf updateWithComic:comic];
    
    [[XKCD sharedInstance] getLatestComic:^(XKCDComic *comic) {
      [weakSelf updateWithComic:comic];
    }];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void) updateWithComic:(XKCDComic*)comic {
  //stored image
  UIImage *image = [UIImage imageWithData:comic.image];
  if (image) {
    self.comicImageView.image = image;
  }

  //download image
  NSString *urlString = comic.imageUrl;
  __weak ViewController *weakSelf = self;
  [UIImage imageFromUrl:urlString
             completion:^(UIImage *image) {
               weakSelf.comicImageView.image = image;
               comic.image = UIImagePNGRepresentation(image);
             }];
  
}

#pragma mark - Actions

- (IBAction)refreshAction:(id)sender {
  __weak ViewController *weakSelf = self;
  [[XKCD sharedInstance] getLatestComic:^(XKCDComic *comic) {
    [weakSelf updateWithComic:comic];
  }];
}

@end
