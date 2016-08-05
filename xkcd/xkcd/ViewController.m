//
//  ViewController.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchManager.h"
#import "NSNumber+Operations.h"
#import "PersistenceManager.h"
#import "Reachability.h"
#import "ShareController.h"
#import "SpotlightManager.h"
#import "ViewController.h"
#import "UIAlertController+SimpleAction.h"
#import "UIColor+XKCD.h"
#import "UIImage+AsyncImage.h"
#import "UIImage+XKCD.h"
#import "XKCD.h"
#import "XKCDAlertController.h"
#import "XKCDExplainedManager.h"

@interface ViewController ()
@property (strong, nonatomic) UIButton *previousButton, *nextButton, *randomButton;
@property (strong, nonatomic) XKCDComic *currentComic;
@property (copy, nonatomic) NSNumber *launchIndex;
@property (nonatomic) BOOL loading, showingLatestComic, showingOldestComic;
@property (strong, nonatomic) XKCDExplainedManager *explained;
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
  
  [self setupToolbar];
  
  [self loadComicWithIndex:nil
               forceUpdate:YES];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  self.explained = [[XKCDExplainedManager alloc] init];
  [self.explained explain];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  [self setScrollViewInsets];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
    self.currentComic = nil;
  }
}

#pragma mark - Properties

- (void) setLoading:(BOOL)loading {
  _loading = loading;
  
  self.loaderView.hidden = !self.loading;
  self.shareButton.enabled = !self.loading;
  self.randomButton.enabled = !self.loading;
  
  BOOL enableNextButton = !self.loading && !self.showingLatestComic;
  self.nextButton.enabled = enableNextButton;
  
  BOOL enablePreviousButton = !self.loading && !self.showingOldestComic;
  self.previousButton.enabled = enablePreviousButton;
  
  if (loading) {
    [self clearViews];
  }
}

#pragma mark - Notifications

- (void) addNotificationObservers {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleShowComicNotification:)
                                               name:ShowComicNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
}

- (void) handleShowComicNotification:(NSNotification*)notification {

  NSDictionary *userInfo = notification.userInfo;
  
  self.launchIndex = userInfo[kIndexKey];
  
  if (self.isViewLoaded) {
    BOOL forceUpdate = self.launchIndex == nil; //force update if not given explicit index.
    [self loadComicWithIndex:self.launchIndex forceUpdate:forceUpdate];
    self.launchIndex = nil;
  }
}

//Update layouts when re-entering foreground.
- (void) handleWillEnterForeground:(NSNotification*)notification {
  [self setScrollViewInsets];
  
  NSNumber *index = nil;
  if (self.launchIndex) {
    index = self.launchIndex;
  } else if (self.currentComic) {
    index = self.currentComic.index;
  }
  
  BOOL forceUpdate = index == nil;
  [self loadComicWithIndex:index
               forceUpdate:forceUpdate];
}

#pragma mark - Actions

//Long pressed previous button
- (void) oldestAction:(UILongPressGestureRecognizer*)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    __weak ViewController *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithOkButtonTitle:@"Jump to oldest"
                                                                             okButtonHandler:^{
                                                                               [weakSelf loadComicWithIndex:@(1)
                                                                                               forceUpdate:NO];
                                                                             }];
    
    [self.navigationController presentViewController:alertController
                                            animated:YES
                                          completion:^{}];
  }
}

- (void) latestAction:(UILongPressGestureRecognizer*)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    __weak ViewController *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithOkButtonTitle:@"Jump to newest"
                                                                             okButtonHandler:^{
                                                                               [weakSelf loadComicWithIndex:nil
                                                                                               forceUpdate:NO];
                                                                             }];
    
    [self.navigationController presentViewController:alertController
                                            animated:YES
                                          completion:^{}];
  }
}

- (void) previousAction:(UIButton*)sender {
  NSLog(@"previous button pressed");
  
  NSNumber *oldestIndex = @(0);
  if ([self.currentComic.index equals:oldestIndex]) return;
  
  NSNumber *previousIndex = [self.currentComic.index subtract:1];
  [self loadComicWithIndex:previousIndex
              forceUpdate:NO];
}

- (void) nextAction:(UIButton*)sender {
  NSLog(@"next button pressed");
  
  NSNumber *latestIndex = [XKCD sharedInstance].latestComicIndex;
  if (self.currentComic.index && latestIndex && [self.currentComic.index equals:latestIndex]) return;
  
  NSNumber *nextIndex = [self.currentComic.index add:1];
  [self loadComicWithIndex:nextIndex
               forceUpdate:NO];
  
}

- (void) randomAction:(UIButton*)sender {
  NSLog(@"random button pressed");
  NSNumber *latestIndex = [XKCD sharedInstance].latestComicIndex;
  if (!latestIndex) return;
  
  NSNumber *randomIndex = [NSNumber randomWithMinimum:@(1)
                                              maximum:latestIndex];
  if (!randomIndex) return;
  
  [self loadComicWithIndex:randomIndex
               forceUpdate:NO];
}

- (IBAction) shareAction:(id)sender {
  ShareController *shareController = [[ShareController alloc] initWithComic:self.currentComic];
  if (!shareController) return;
  
  [self.navigationController presentViewController:shareController
                                          animated:YES
                                        completion:^{}];
}

- (IBAction) showFavoritesAction:(id)sender {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Favorites"
                                                       bundle:[NSBundle mainBundle]];
  UINavigationController *favoritesNavigationController = [storyboard instantiateInitialViewController];
  FavoritesViewController *favoritesViewController = favoritesNavigationController.viewControllers.firstObject;
  favoritesViewController.delegate = self;
  
  [self.navigationController presentViewController:favoritesNavigationController
                                          animated:YES
                                        completion:^{}];
}

- (IBAction) toggleFavoriteAction:(id)sender {
  [[XKCD sharedInstance] toggleFavorite:self.currentComic.index];
  [self updateToggleFavoritesButton:self.currentComic];
}

#pragma mark - Private

//Load comic with index. Attempts local Core Data load, if fails, performs HTTP request.
//pass forceUpdate = YES to force http GET even after successul fetch.
- (void) loadComicWithIndex:(NSNumber*)index forceUpdate:(BOOL)forceUpdate {
  
  self.loading = YES;
  
  //Finialize fetch of load from http.
  __weak ViewController *weakSelf = self;
  void(^finalizeWithComic)(XKCDComic *comic) = ^void(XKCDComic *comic) {
    
    if (comic) {
      weakSelf.currentComic = comic;
    }
    
    [weakSelf updateViewsWithComic:comic];
  };

  XKCDComic *fetchedComic = [[XKCD sharedInstance] fetchComicWithIndex:index];
  //Fetched comic from Core Data
  if (fetchedComic) {
    finalizeWithComic(fetchedComic);
    
    //No need to for http update, return early after successful fetch.
    if (!forceUpdate) return;
  }
  
  //Get from http if you have a network connection (or forceUpdate==YES)
  //Return early and show error if not reachable.
  BOOL reachable = [self isReachable];
  if (!reachable && !fetchedComic) {
    self.noNetworkLabel.hidden = NO;
    self.loading = NO;
    return;
  }
  
  [[XKCD sharedInstance] getComicWithIndex:index
                                completion:^(XKCDComic *comic) {
                                  [[SpotlightManager sharedManager] indexComic:comic];
                                  finalizeWithComic(comic);
                                }];
}

- (BOOL) isReachable {
  return [Reachability reachabilityForInternetConnection].currentReachabilityStatus != NotReachable;
}

//Sets UIEdgeInsets propert to on scroll view with current orientation bar sizes.
- (void) setScrollViewInsets {
  CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
  BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
  CGFloat statusBarHeight = statusBarHidden ? 0.0F : [UIApplication sharedApplication].statusBarFrame.size.height;
  CGFloat topBarsHeight = navBarHeight + statusBarHeight;
  self.scrollView.barInsets = UIEdgeInsetsMake(topBarsHeight, 0.0F, 0.0F, 0.0F);
  
  self.imageTopConstraint.constant = topBarsHeight;
}

//update the favorites button
- (void) updateToggleFavoritesButton:(XKCDComic*)comic {
  BOOL favorite = comic.favorite != nil;
  self.toggleFavoriteButton.image = [UIImage heartImageFilled:favorite landscape:NO];
  self.toggleFavoriteButton.landscapeImagePhone = [UIImage heartImageFilled:favorite landscape:YES];
  self.toggleFavoriteButton.enabled = YES;
}

- (void) clearViews {
  self.title = nil;
  self.noNetworkLabel.hidden = YES;
  self.toggleFavoriteButton.enabled = NO;
  self.toggleFavoriteButton.image = [UIImage heartImageFilled:NO landscape:NO];
  self.toggleFavoriteButton.landscapeImagePhone = [UIImage heartImageFilled:NO landscape:YES];
  [self.scrollView setImage:nil];
}

- (void) updateViewsWithComic:(XKCDComic*)comic {
  if (!comic) return;
  
  //hide no network error.
  self.noNetworkLabel.hidden = YES;
  
  //nav bar title
  self.title = comic.title;
  
  //update the toolbar buttons
  if (self.currentComic.index) {
    //latest comic
    NSNumber *latestIndex = [XKCD sharedInstance].latestComicIndex;
    self.showingLatestComic = [self.currentComic.index equals:latestIndex];
    
    //oldest comic
    NSNumber *firstIndex = @(1);
    self.showingOldestComic = [self.currentComic.index equals:firstIndex];
  }
  
  //blacklist
  if ([[XKCD sharedInstance] comicIsBlacklisted:comic.index]) {
    XKCDAlertController *blacklistAlertController = [XKCDAlertController blacklistAlertControllerWithComic:comic];
    [self.navigationController presentViewController:blacklistAlertController
                                            animated:YES
                                          completion:^{}];
    return;
  }
  
  //image
  __weak ViewController *weakSelf = self;
  [comic getImage:^(UIImage * _Nonnull image) {
    [weakSelf.scrollView setImage:image];
    weakSelf.loading = NO;
    
    //favorites button
    [weakSelf updateToggleFavoritesButton:comic];
    
    if (!image) {
      XKCDAlertController *imageAlertController = [XKCDAlertController imageErrorAlertControllerWithComic:comic];
      [self.navigationController presentViewController:imageAlertController
                                              animated:YES
                                            completion:^{}];
    }
  }];
}

- (void) setupToolbar {
  //Previous
  self.previousButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.previousButton setTitle:@"<Prev" forState:UIControlStateNormal];
  [self.previousButton addTarget:self action:@selector(previousAction:) forControlEvents:UIControlEventTouchUpInside];
  self.previousButton.frame = CGRectMake(0.0F, 0.0F, 60.0F, 34.0F);
  UILongPressGestureRecognizer *previousLongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(oldestAction:)];
  [self.previousButton addGestureRecognizer:previousLongPressRecognizer];
  UIBarButtonItem *previousButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.previousButton];
  
  //Random
  self.randomButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.randomButton setTitle:@"Random" forState:UIControlStateNormal];
  [self.randomButton addTarget:self action:@selector(randomAction:) forControlEvents:UIControlEventTouchUpInside];
  self.randomButton.frame = CGRectMake(0.0F, 0.0F, 60.0F, 34.0F);
  UIBarButtonItem *randomButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.randomButton];
  
  //Next
  self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.nextButton setTitle:@"Next>" forState:UIControlStateNormal];
  [self.nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
  self.nextButton.frame = CGRectMake(0.0F, 0.0F, 60.0F, 34.0F);
  UILongPressGestureRecognizer *nextLongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(latestAction:)];
  [self.nextButton addGestureRecognizer:nextLongPressRecognizer];
  UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextButton];
  
  UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  
  NSArray <UIBarButtonItem*>*items = @[flexibleSpaceItem, previousButtonItem, flexibleSpaceItem, randomButtonItem, flexibleSpaceItem, nextButtonItem, flexibleSpaceItem];
  [self setToolbarItems:items];
  
  [self.navigationController setToolbarHidden:NO];
}

#pragma mark - FavoritesViewControllerDelegte

- (void) favoritesViewController:(FavoritesViewController *)favoritesViewController
      didDeleteFavoriteWithIndex:(NSNumber *)index {
  if ([index equals:self.currentComic.index]) {
    [self updateToggleFavoritesButton:self.currentComic];
  }
}

- (void) favoritesViewController:(FavoritesViewController *)favoritesViewController
         didSelectComicWithIndex:(NSNumber *)index {
  [self loadComicWithIndex:index
               forceUpdate:NO];
}

@end
