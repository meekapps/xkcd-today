//
//  FavoritesViewController.m
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "FavoriteTableViewCell.h"
#import "FavoritesViewController.h"
#import "XKCD.h"
#import "XKCDComic.h"

typedef NS_ENUM(NSUInteger, Segment) {
    SegmentFavorites,
    SegmentAllDownloaded
};

@interface FavoritesViewController ()
@property (strong, nonatomic) NSArray<XKCDComic*> *allDownloaded;
@property (strong, nonatomic) NSArray<XKCDComic*> *favorites;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) Segment selectedSegment;
@end

@implementation FavoritesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.allDownloaded = [XKCD.sharedInstance fetchAllDownloaded];
  self.favorites = [XKCD.sharedInstance fetchFavorites];
  self.selectedSegment = SegmentFavorites;
  [self.tableView reloadData];
  self.tableView.estimatedRowHeight = 60.0F;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  [self showOrHideEditButton];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
  self.favorites = [XKCD.sharedInstance fetchFavorites];
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

- (IBAction)changedSegment:(UISegmentedControl *)sender {
    self.selectedSegment = sender.selectedSegmentIndex;
    [self.tableView reloadData];
    [self showOrHideEditButton];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (self.selectedSegment) {
    case SegmentFavorites:
      return self.favorites.count;
    case SegmentAllDownloaded:
      return self.allDownloaded.count;
    default:
      return 0;
  }
}

- (NSString*) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
  return @"Remove";
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FavoriteTableViewCell class])];
  switch (self.selectedSegment) {
    case SegmentFavorites:
      cell.comic = self.favorites[indexPath.row];
      break;
    case SegmentAllDownloaded:
      cell.comic = self.allDownloaded[indexPath.row];
      break;
    default:
      cell.comic = nil;
      break;
  }
  return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (self.selectedSegment) {
    case SegmentFavorites:
      return YES;
    case SegmentAllDownloaded: // Fall through
    default:
      return NO;
  }
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (self.selectedSegment) {
    case SegmentFavorites:
      return YES;
    case SegmentAllDownloaded: // Fall through
    default:
      return NO;
  }
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
  
  [XKCD.sharedInstance moveFavoriteFromIndex:sourceIndexPath.row
                                       toIndex:destinationIndexPath.row];
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
  [XKCD.sharedInstance toggleFavorite:index];
  self.favorites = [XKCD.sharedInstance fetchFavorites];
  
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
  if (self.favorites && self.favorites.count > 0 && self.selectedSegment == SegmentFavorites) {
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
  } else {
    self.navigationItem.leftBarButtonItem = nil;
  }
}

@end
