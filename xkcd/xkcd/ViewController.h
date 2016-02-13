//
//  ViewController.h
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "ComicScrollView.h"
#import "FavoritesViewController.h"
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <FavoritesViewControllerDelegate>

@property (weak, nonatomic) IBOutlet ComicScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleFavoriteButton, *showFavoritesButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *noNetworkLabel;

- (IBAction) toggleFavoriteAction:(id)sender;
- (IBAction) showFavoritesAction:(id)sender;

@end

