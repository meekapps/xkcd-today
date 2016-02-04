//
//  FavoritesViewController.h
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoritesViewController;
@protocol FavoritesViewControllerDelegate <NSObject>
- (void) favoritesViewController:(FavoritesViewController*)favoritesViewController
      didDeleteFavoriteWithIndex:(NSNumber*)index;
- (void) favoritesViewController:(FavoritesViewController*)favoritesViewController
         didSelectComicWithIndex:(NSNumber*)index;
@end

@interface FavoritesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<FavoritesViewControllerDelegate>delegate;

- (IBAction)doneAction:(id)sender;

@end
