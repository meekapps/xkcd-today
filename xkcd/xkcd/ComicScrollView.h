//
//  ComicScrollView.h
//  xkcd
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComicScrollView : UIScrollView <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *comicImageView;

- (void) setImage:(UIImage*)image;

@end
