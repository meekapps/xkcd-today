//
//  TodayViewController.h
//  xkcd today
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

@import UIKit;

@interface TodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)tappedView:(id)sender;

@end
