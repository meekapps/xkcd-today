//
//  TodayViewController.h
//  xkcd today
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Meek Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel, *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)tappedView:(id)sender;

@end
