//
//  FavoritesViewController.m
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)doneAction:(id)sender {
  [self.navigationController dismissViewControllerAnimated:YES
                                                completion:^{}];
}

@end
