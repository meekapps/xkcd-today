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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton, *previousButton, *randomButton, *addToFavoritesButton, *favoritesButton;

- (IBAction) previousAction:(id)sender;
- (IBAction) nextAction:(id)sender;
- (IBAction) randomAction:(id)sender;
- (IBAction) addToFavoritesAction:(id)sender;
- (IBAction) favoritesAction:(id)sender;

@end

