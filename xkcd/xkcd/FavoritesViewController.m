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
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
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

@end
