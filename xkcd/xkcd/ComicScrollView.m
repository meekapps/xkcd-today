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
@property (strong, nonatomic) UIImageView *comicImageView;
@end

@implementation ComicScrollView

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.delegate = self;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapRecognizer];
  }
  return self;
}

- (void) setComicImage:(UIImage*)image {
  _comicImage = image;
  
  self.comicImageView.image = image;
  self.comicImageView.frame = CGRectMake(0.0F, 0.0F, image.size.width, image.size.height);
  self.contentSize = CGSizeMake(image.size.width, image.size.height);
  
  [self updateZoom];
  
  [self centerContent];

}

- (UIImageView*) comicImageView {
  if (!_comicImageView) {
    _comicImageView = [[UIImageView alloc] init];
    _comicImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_comicImageView];
  }
  return _comicImageView;
}

#pragma mark - Actions

- (void) handleDoubleTap:(UITapGestureRecognizer*)recognier {
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
  CGFloat minimumZoomScale = MIN(widthRatio, heightRatio);
  minimumZoomScale = MIN(1, minimumZoomScale); //min zoom be <= than 1
  self.minimumZoomScale = minimumZoomScale;

  //Maximum
  CGFloat maximumZoomScale = MAX(widthRatio, heightRatio);
  maximumZoomScale = MAX(1, maximumZoomScale); //max zoom should be >= 1
  self.maximumZoomScale = maximumZoomScale;
  
  //Zoom to fit
  self.zoomScale = self.minimumZoomScale;
  NSLog(@"setting minimum zoom scale: %@, maximum %@", @(minimumZoomScale), @(maximumZoomScale));
}

- (void) centerContent {
  CGFloat top = kDefaultPadding, left = kDefaultPadding;
  if (self.contentSize.width < self.bounds.size.width) {
    left = (self.bounds.size.width - self.contentSize.width) * 0.5F;
  }
  
  if (self.contentSize.height < self.bounds.size.height) {
    top = (self.bounds.size.height - self.contentSize.height) * 0.5F;
  }
  self.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  [self centerContent];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.comicImageView;
}

@end
