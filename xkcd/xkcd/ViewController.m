//
//  ViewController.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "LaunchManager.h"
#import "NSNumber+Operations.h"
#import "PersistenceManager.h"
#import "ViewController.h"
#import "UIColor+XKCD.h"
#import "UIImage+AsyncImage.h"
#import "XKCD.h"

static NSInteger kHoverboardIndex = 1608;
static NSString *kHoverboardUrl = @"https://xkcd.com/1608/";

@interface ViewController ()
@property (copy, nonatomic) NSNumber *currentIndex, *launchIndex;
@property (strong, nonatomic) UIActivityIndicatorView *loaderView;
@property (nonatomic) BOOL loaderVisible;
@end

@implementation ViewController

#pragma mark - Lifecycle

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self addNotificationObservers];
  }
  return self;
}

- (void) viewDidLoad {
  [super viewDidLoad];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (self.launchIndex) {
      [self loadComicWithIndex:self.launchIndex];
    } else {
      [self initialLoad];
    }
  });
}

- (void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (void) setLoaderVisible:(BOOL)visible {
  _loaderVisible = visible;
  
  //TODO: new loader
}

- (UIActivityIndicatorView*) loaderView {
  if (!_loaderView) {
    _loaderView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  }
  return _loaderView;
}

#pragma mark - Notifications

- (void) addNotificationObservers {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleOrientationChangeNotification:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleShowComicNotification:)
                                               name:ShowComicNotification
                                             object:nil];
}

- (void) handleOrientationChangeNotification:(NSNotification*)notification {
  [self setScrollViewInsets];
}

- (void) handleShowComicNotification:(NSNotification*)notification {

  NSDictionary *userInfo = notification.userInfo;
  
  self.launchIndex = userInfo[kIndexKey];
  
  if (self.isViewLoaded) {
    if (self.launchIndex) {
      [self loadComicWithIndex:self.launchIndex];
    } else {
      [self initialLoad];
    }
  }
}

#pragma mark - Actions

//- (IBAction) refreshAction:(id)sender {
//  self.loaderVisible = YES;
//  __weak ViewController *weakSelf = self;
//  [[XKCD sharedInstance] getComicWithIndex:self.currentIndex
//                                completion:^(XKCDComic *comic) {
//    [weakSelf updateViewsWithComic:comic];
//    weakSelf.loaderVisible = NO;
//  }];
//}

- (IBAction) previousAction:(id)sender {
  NSLog(@"previous button pressed");
  
  NSNumber *oldestIndex = @(0);
  if ([self.currentIndex equals:oldestIndex]) return;
  
  NSNumber *previousIndex = [self.currentIndex subtract:1];
  [self loadComicWithIndex:previousIndex];
}

- (IBAction) nextAction:(id)sender {
  NSLog(@"next button pressed");
  
  NSNumber *latestIndex = [XKCD sharedInstance].latestComicIndex;
  if (self.currentIndex && latestIndex && [self.currentIndex equals:latestIndex]) return;
  
  NSNumber *nextIndex = [self.currentIndex add:1];
  [self loadComicWithIndex:nextIndex];
  
}

- (IBAction) randomAction:(id)sender {
  NSLog(@"random button pressed");
  NSNumber *latestIndex = [XKCD sharedInstance].latestComicIndex;
  if (!latestIndex) return;
  
  NSNumber *randomIndex = [NSNumber randomWithMinimum:@(1)
                                              maximum:latestIndex];
  if (!randomIndex) return;
  
  [self loadComicWithIndex:randomIndex];
}

- (IBAction)favoritesAction:(id)sender {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Favorites"
                                                       bundle:[NSBundle mainBundle]];
  UINavigationController *favoritesNavigationController = [storyboard instantiateInitialViewController];
  FavoritesViewController *favoritesViewController = favoritesNavigationController.viewControllers.firstObject;
  favoritesViewController.delegate = self;
  [self.navigationController presentViewController:favoritesNavigationController
                                          animated:YES
                                        completion:^{
                                        }];
}

- (IBAction) addToFavoritesAction:(id)sender {
  [[XKCD sharedInstance] addToFavorites:self.currentIndex];
}

#pragma mark - Private

- (void) initialLoad {
  //Fetch most recent persisted comic from Core Data.
  __weak ViewController *weakSelf = self;
  XKCDComic *fetchedComic = [[XKCD sharedInstance] fetchLatestComic];
  if (fetchedComic) {
    weakSelf.currentIndex = [fetchedComic.index copy];
    [weakSelf updateViewsWithComic:fetchedComic];
  }
  
  //GET latest comic from HTTP request, update UI if it is new.
  [[XKCD sharedInstance] getLatestComic:^(XKCDComic *httpComic) {
    if (![fetchedComic.index equals:httpComic.index]) {
      weakSelf.currentIndex = [httpComic.index copy];
      [weakSelf updateViewsWithComic:httpComic];
    }
  }];
}

//Load comic with index. Attempts local Core Data load, if fails, performs HTTP request.
- (void) loadComicWithIndex:(NSNumber*)index {
  
  self.loaderVisible = YES;
  
  __weak ViewController *weakSelf = self;
  void(^finalizeWithComic)(XKCDComic *comic) = ^void(XKCDComic *comic) {
    if (comic) weakSelf.currentIndex = [index copy];
    
    [weakSelf updateViewsWithComic:comic];
    
    weakSelf.loaderVisible = NO;
  };

  XKCDComic *fetchedComic = [[XKCD sharedInstance] fetchComicWithIndex:index];
  //Fetched comic from Core Data
  if (fetchedComic) {
    finalizeWithComic(fetchedComic);
                                      
  //Not in Core Data, get from http.
  } else {
    [[XKCD sharedInstance] getComicWithIndex:index
                                  completion:^(XKCDComic *comic) {
                                    finalizeWithComic(comic);
                                  }];
  }
}

//Sets UIEdgeInsets propert to on scroll view with current orientation bar sizes.
- (void) setScrollViewInsets {
  CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
  CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
  CGFloat topBarsHeight = navBarHeight + statusBarHeight;
  CGFloat toolbarHeight = self.toolbar.bounds.size.height;
  self.scrollView.barInsets = UIEdgeInsetsMake(topBarsHeight, 0.0F, toolbarHeight, 0.0F);
}

- (void) updateViewsWithComic:(XKCDComic*)comic {
  if (!comic) return;
  
  //nav bar title
  self.title = comic.title;
  
  //update the favorites button
  if (comic.favorite != nil) {
    //TODO: show
  } else {
    //TODO: hide
  }
  
  //update the toolbar buttons
  if (self.currentIndex) {
    //latest comic
    NSNumber *latestIndex = [XKCD sharedInstance].latestComicIndex;
    self.nextButton.enabled = ![self.currentIndex equals:latestIndex];
    
    //oldest comic
    NSNumber *firstIndex = @(1);
    self.previousButton.enabled = ![self.currentIndex equals:firstIndex];
  }
  
  //set the stored image, if possible
  UIImage *image = [UIImage imageWithData:comic.image];
  if (image) {
    [self.scrollView setImage:image];
    [self setScrollViewInsets];
    return;
  }
  
  //download image if it hasn't been already and save in Core Data.
  NSString *urlString = comic.imageUrl;
  __weak ViewController *weakSelf = self;
  [UIImage imageFromUrl:urlString
             completion:^(UIImage *image) {
               
               [weakSelf.scrollView setImage:image];
               
               if (image) {
                 //updates UI
                 [weakSelf setScrollViewInsets];
                 
                 //sets managed object image in context to be persisted.
                 comic.image = UIImagePNGRepresentation(image);
                 [[PersistenceManager sharedManager] saveContext];
               }
             }];
  
  //hoverboard
  if ([comic.index equals:@(kHoverboardIndex)]) {
    [self showHoverboardError];
    return;
  }
}

- (void) showHoverboardError {
  NSString *message = @"This app is not hoverboard enabled. Play in browser?";
  UIAlertController *hoverboardAlert = [UIAlertController alertControllerWithTitle:@"Error -41"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                       }];
  [hoverboardAlert addAction:cancelAction];
  UIAlertAction *playAction = [UIAlertAction actionWithTitle:@"Play"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kHoverboardUrl]];
                                                     }];
  [hoverboardAlert addAction:playAction];
  [self.navigationController presentViewController:hoverboardAlert animated:YES completion:^{
  }];
  
}

#pragma mark - FavoritesViewControllerDelegte

- (void) favoritesViewController:(FavoritesViewController *)favoritesViewController
         didSelectComicWithIndex:(NSNumber *)index {
  [self loadComicWithIndex:index];
}

@end
