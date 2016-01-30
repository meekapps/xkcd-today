//
//  ViewController.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "PersistenceController.h"
#import "ViewController.h"
#import "UIImage+AsyncImage.h"
#import "XKCD.h"

static CGFloat const kDefaultPadding = 8.0F;

@interface ViewController ()
@property (strong, nonatomic) UIImageView *comicImageView;
@property (nonatomic) NSUInteger currentIndex;
@property (strong, nonatomic) UIActivityIndicatorView *loaderView;
@property (nonatomic) BOOL loaderVisible;
@property (strong, nonatomic) UIBarButtonItem *refreshButtonItem;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self initialLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Overrides

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

#pragma mark - UIScrollViewDelegate

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.comicImageView;
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
  //TODO: previous
  NSLog(@"previous button pressed");
}

- (IBAction)nextAction:(id)sender {
  //TODO: next
  NSLog(@"next button pressed");
}

- (IBAction)randomAction:(id)sender {
  //TODO: random
  NSLog(@"random button pressed");
}

#pragma mark - Private

- (void) initialLoad {
  //Fetch most recent persisted comic from Core Data.
  __weak ViewController *weakSelf = self;
  [[XKCD sharedInstance] fetchLatestComic:^(XKCDComic *fetchedComic) {
    if (fetchedComic) {
      weakSelf.currentIndex = fetchedComic.index.unsignedIntegerValue;
      [weakSelf updateViewsWithComic:fetchedComic];
    }
    
    //GET latest comic from HTTP request, update UI if it is new.
    [[XKCD sharedInstance] getLatestComic:^(XKCDComic *httpComic) {
      if (fetchedComic.index != httpComic.index) {
        weakSelf.currentIndex = httpComic.index.unsignedIntegerValue;
        [weakSelf updateViewsWithComic:httpComic];
      }
    }];
  }];
}

- (void) updateComicImageWithComic:(XKCDComic*)comic {
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

- (void) updateViewsWithComic:(XKCDComic*)comic {
  if (!comic) return;
  
  //nav bar title
  self.title = comic.title;
  
  [self updateComicImageWithComic:comic];
}

@end
