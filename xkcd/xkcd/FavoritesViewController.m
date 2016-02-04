//
//  FavoritesViewController.m
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "FavoriteTableViewCell.h"
#import "FavoritesViewController.h"
#import "XKCD.h"
#import "XKCDComic.h"

@interface FavoritesViewController ()
@property (strong, nonatomic) NSArray<XKCDComic*> *favorites;
@end

@implementation FavoritesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.favorites = [[XKCD sharedInstance] fetchFavorites];
  [self.tableView reloadData];
  
  [self showOrHideEditButton];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  self.favorites = [[XKCD sharedInstance] fetchFavorites];
  [self.tableView reloadData];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  
  [self.tableView setEditing:editing animated:animated];
  
  if (animated) {
    //animate hiding the right done button.
    [UIView transitionWithView:self.navigationController.navigationBar
                      duration:0.2F
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                    } completion:^(BOOL finished) {
                    }];
  }
  self.navigationItem.rightBarButtonItem.enabled = !editing;
  self.navigationItem.rightBarButtonItem.tintColor = editing ? [UIColor clearColor] : [UIColor blackColor];
}

#pragma mark - Actions

- (IBAction)doneAction:(id)sender {
  [self.navigationController dismissViewControllerAnimated:YES
                                                completion:^{}];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.favorites.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FavoriteTableViewCell class])];
  cell.comic = self.favorites[indexPath.row];
  return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self deleteFavoriteAtIndexPath:indexPath];
  }
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath {
  
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.delegate respondsToSelector:@selector(favoritesViewController:didSelectComicWithIndex:)]) {
    XKCDComic *comic = self.favorites[indexPath.row];
    [self.delegate favoritesViewController:self didSelectComicWithIndex:comic.index];
  }
  
  [self.navigationController dismissViewControllerAnimated:YES
                                                completion:^{
  }];
}

#pragma mark - Private

- (void) deleteFavoriteAtIndexPath:(NSIndexPath*)indexPath {
  XKCDComic *comic = self.favorites[indexPath.row];
  NSNumber *index = comic.index;
  
  //remove from data source
  [[XKCD sharedInstance] toggleFavorite:index];
  self.favorites = [[XKCD sharedInstance] fetchFavorites];
  
  //update table view
  [self.tableView beginUpdates];
  [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.tableView endUpdates];
  
  //edit button
  [self showOrHideEditButton];
  
  //stop editing if that was the only favorite
  if (self.favorites.count == 0 && self.editing) {
    [self setEditing:NO animated:YES];
  }
  
  //inform delegate
  if ([self.delegate respondsToSelector:@selector(favoritesViewController:didDeleteFavoriteWithIndex:)]) {
    [self.delegate favoritesViewController:self didDeleteFavoriteWithIndex:index];
  }
}

- (void) showOrHideEditButton {
  if (self.favorites && self.favorites.count > 0) {
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
  } else {
    self.navigationItem.leftBarButtonItem = nil;
  }
}

@end
