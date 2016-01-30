//
//  ViewController.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "NSNumber+Operations.h"
#import "PersistenceController.h"
#import "ViewController.h"
#import "UIImage+AsyncImage.h"
#import "XKCD.h"

static CGFloat const kDefaultPadding = 8.0F;

@interface ViewController ()
@property (strong, nonatomic) UIImageView *comicImageView;
@property (copy, nonatomic) NSNumber *currentIndex;
@property (strong, nonatomic) UIActivityIndicatorView *loaderView;
@property (nonatomic) BOOL loaderVisible;
@property (strong, nonatomic) UIBarButtonItem *refreshButtonItem;
@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self initialLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (void) setComicImage:(UIImage*)image {
  self.comicImageView.image = image;
  
  //Calculate frame
  CGFloat padding = kDefaultPadding;
  CGFloat width = self.scrollView.bounds.size.width - padding * 2.0F;
  CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
  CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
  CGFloat toolBarHeight = self.toolbar.bounds.size.height;
  CGFloat height = self.scrollView.bounds.size.height - navBarHeight - statusBarHeight - toolBarHeight - padding * 2.0F;
  self.comicImageView.frame = CGRectMake(padding, padding, width, height);
  
  self.scrollView.contentSize = self.comicImageView.bounds.size;
}

- (void) setLoaderVisible:(BOOL)visible {
  _loaderVisible = visible;
  
  if (visible) {
    self.refreshButtonItem = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *loaderButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.loaderView];
    [self.loaderView startAnimating];
    self.navigationItem.rightBarButtonItem = loaderButtonItem;
  } else {
    self.navigationItem.rightBarButtonItem = self.refreshButtonItem;
  }
}

- (UIActivityIndicatorView*) loaderView {
  if (!_loaderView) {
    _loaderView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  }
  return _loaderView;
}

- (UIImageView*) comicImageView {
  if (!_comicImageView) {
    _comicImageView = [[UIImageView alloc] init];
    _comicImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:_comicImageView];
  }
  return _comicImageView;
}

#pragma mark - Actions

- (IBAction)refreshAction:(id)sender {
  self.loaderVisible = YES;
  __weak ViewController *weakSelf = self;
  [[XKCD sharedInstance] getLatestComic:^(XKCDComic *comic) {
    [weakSelf updateViewsWithComic:comic];
    weakSelf.loaderVisible = NO;
  }];
}

- (IBAction)previousAction:(id)sender {
  NSLog(@"previos button pressed");
  
  NSNumber *oldestIndex = @(0);
  if ([self.currentIndex equals:oldestIndex]) return;
  
  NSNumber *previousIndex = [[self.currentIndex subtract:1] copy];
  [self loadComicWithIndex:previousIndex];
}

- (IBAction)nextAction:(id)sender {
  NSLog(@"next button pressed");
  
  NSNumber *latestIndex = [XKCD sharedInstance].latestComicIndex;
  if (self.currentIndex && latestIndex && [self.currentIndex equals:latestIndex]) return;
  
  NSNumber *nextIndex = [[self.currentIndex add:1] copy];
  [self loadComicWithIndex:nextIndex];
  
}

- (IBAction)randomAction:(id)sender {
  NSLog(@"random button pressed");
  NSNumber *latestIndex = [XKCD sharedInstance].latestComicIndex;
  if (!latestIndex) return;
  
  NSNumber *randomIndex = [NSNumber randomWithMinimum:@(1)
                                              maximum:latestIndex];
  if (!randomIndex) return;
  
  [self loadComicWithIndex:randomIndex];
}

#pragma mark - Private

- (void) initialLoad {
  //Fetch most recent persisted comic from Core Data.
  __weak ViewController *weakSelf = self;
  [[XKCD sharedInstance] fetchLatestComic:^(XKCDComic *fetchedComic) {
    if (fetchedComic) {
      weakSelf.currentIndex = [fetchedComic.index copy];
      [weakSelf updateViewsWithComic:fetchedComic];
    }
    
    //GET latest comic from HTTP request, update UI if it is new.
    [[XKCD sharedInstance] getLatestComic:^(XKCDComic *httpComic) {
      if (fetchedComic.index.unsignedIntegerValue != httpComic.index.unsignedIntegerValue) {
        weakSelf.currentIndex = [httpComic.index copy];
        [weakSelf updateViewsWithComic:httpComic];
      }
    }];
  }];
}

- (void) loadComicWithIndex:(NSNumber*)index {
  if (!index) return;
  
  __weak ViewController *weakSelf = self;
  [[XKCD sharedInstance] fetchComicWithIndex:index
                                  completion:^(XKCDComic *comic) {
                                    //Fetched comic from Core Data
                                    if (comic) {
                                      [weakSelf updateViewsWithComic:comic];
                                      weakSelf.currentIndex = [index copy];
                                      
                                      //Not in Core Data, get from http.
                                    } else {
                                      [[XKCD sharedInstance] getComicWithIndex:index
                                                                    completion:^(XKCDComic *comic) {
                                                                      [weakSelf updateViewsWithComic:comic];
                                                                      weakSelf.currentIndex = [index copy];
                                                                    }];
                                    }
                                  }];
}

- (void) updateViewsWithComic:(XKCDComic*)comic {
  if (!comic) return;
  
  //nav bar title
  self.title = comic.title;
  
  //set the stored image, if possible
  UIImage *image = [UIImage imageWithData:comic.image];
  if (image) {
    [self setComicImage:image];
    return;
  }
  
  //download image if it hasn't been already and save in Core Data.
  NSString *urlString = comic.imageUrl;
  __weak ViewController *weakSelf = self;
  [UIImage imageFromUrl:urlString
             completion:^(UIImage *image) {
               
               //updates UI
               [weakSelf setComicImage:image];
               
               //sets managed object image in context to be persisted.
               comic.image = UIImagePNGRepresentation(image);
               [[PersistenceController sharedInstance] saveContext];
             }];
}

#pragma mark - UIScrollViewDelegate

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.comicImageView;
}

@end
