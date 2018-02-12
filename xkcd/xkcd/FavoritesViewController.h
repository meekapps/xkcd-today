//
//  FavoritesViewController.h
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

@import UIKit;

@class FavoritesViewController;
@class PanInteractiveTransition;

@protocol FavoritesViewControllerDelegate <NSObject>
- (void) favoritesViewController:(FavoritesViewController*)favoritesViewController
      didDeleteFavoriteWithIndex:(NSNumber*)index;
- (void) favoritesViewController:(FavoritesViewController*)favoritesViewController
         didSelectComicWithIndex:(NSNumber*)index;
@end

@interface FavoritesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<FavoritesViewControllerDelegate>delegate;
@property (weak, nonatomic) PanInteractiveTransition *panInteractiveTransition;

- (IBAction)doneAction:(id)sender;

@end
