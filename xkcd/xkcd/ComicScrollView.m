//
//  ComicScrollView.m
//  xkcd
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "ComicScrollView.h"

static CGFloat const kDefaultPadding = 20.0F;

@interface ComicScrollView()
@end

@implementation ComicScrollView

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.delegate = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.comicImageView.translatesAutoresizingMaskIntoConstraints = NO;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapRecognizer];
  }
  return self;
}

- (void) setImage:(UIImage*)image {
  self.comicImageView.image = image;

  [self updateZoom];
}

#pragma mark - Actions

- (void) handleDoubleTap:(UITapGestureRecognizer*)recognizer {
  if(self.zoomScale > self.minimumZoomScale) {
    [self setZoomScale:self.minimumZoomScale animated:YES];
  } else {
    [self setZoomScale:self.maximumZoomScale animated:YES];
  }

}

#pragma mark - Private

- (void) updateZoom {
  
  CGFloat widthRatio = self.bounds.size.width / self.comicImageView.image.size.width;
  CGFloat heightRatio = self.bounds.size.height / self.comicImageView.image.size.height;
  
  //Minimum
  CGFloat startingZoomScale = MIN(widthRatio, heightRatio);
  CGFloat minimumZoomScale = MIN(1, startingZoomScale); //min zoom be <= than 1
  self.minimumZoomScale = minimumZoomScale;

  //Maximum
  CGFloat maximumZoomScale = MAX(widthRatio, heightRatio);
  maximumZoomScale = MAX(1, maximumZoomScale); //max zoom should be >= 1
  self.maximumZoomScale = maximumZoomScale;
  
  //Zoom to fit
  self.zoomScale = startingZoomScale;

  NSLog(@"setting minimum zoom scale: %@, maximum %@, starting: %@", @(minimumZoomScale), @(maximumZoomScale), @(startingZoomScale));
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.comicImageView;
}

@end
