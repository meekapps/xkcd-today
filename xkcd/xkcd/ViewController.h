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
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIButton *previousButton, *nextButton, *randomButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toggleFavoriteButton, *showFavoritesButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaderView;

- (IBAction) oldestAction:(id)sender;
- (IBAction) latestAction:(id)sender;
- (IBAction) previousAction:(id)sender;
- (IBAction) nextAction:(id)sender;
- (IBAction) randomAction:(id)sender;
- (IBAction) toggleFavoriteAction:(id)sender;
- (IBAction) showFavoritesAction:(id)sender;

@end

