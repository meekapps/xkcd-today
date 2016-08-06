//
//  ComicScrollView.h
//  xkcd
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Meek Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComicScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic) UIEdgeInsets barInsets;
@property (weak, nonatomic) IBOutlet UIImageView *comicImageView;

- (void) setImage:(UIImage*)image;
- (void) setImage:(UIImage*)image animated:(BOOL)animated;

@end
