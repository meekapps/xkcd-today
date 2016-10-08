//
//  MessagesViewController.h
//  xkcd message
//
//  Created by Mike Keller on 10/7/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <Messages/Messages.h>

@interface MessagesViewController : MSMessagesAppViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)shareAction:(id)sender;

@end
