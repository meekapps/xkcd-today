//
//  ViewController.h
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *comicImageView;

- (IBAction)refreshAction:(id)sender;

@end

