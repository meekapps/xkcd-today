//
//  ComicScrollView.m
//  xkcd
//
//  Created by Mike Keller on 1/30/16.
//  Copyright © 2016 Meek Apps. All rights reserved.
//

#import "ComicScrollView.h"

static CGFloat const kDefaultPadding = 10.0F;

@interface ComicScrollView()
@end

@implementation ComicScrollView

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.delegate = self;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateZoomLevels)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
  }
  return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIDeviceOrientationDidChangeNotification
                                                object:nil];
}

- (void) setImage:(UIImage*)image {

  self.comicImageView.image = image;

  [self updateZoomLevels];
  [self centerContent];
}

- (void) setBarInsets:(UIEdgeInsets)barInsets {
  _barInsets = barInsets;
  
  [self updateZoomLevels];
  [self centerContent];
}

#pragma mark - Actions

- (void) handleDoubleTap:(UITapGestureRecognizer*)recognizer {
  
  //Zoomed out any amount, zoom out
  if(self.zoomScale > self.minimumZoomScale) {
    [self setZoomScale:self.minimumZoomScale animated:YES];
    
  //Zoom in centered to tap point.
  } else {
    CGPoint tapPoint = [recognizer locationInView:self];
    CGRect zoomRect = [self zoomRectWithPoint:tapPoint scale:self.maximumZoomScale];
    [self zoomToRect:zoomRect animated:YES];
  }

}

#pragma mark - Private

//The vertical ratio of displayable area to content size.
- (CGFloat) heightRatio {

  CGFloat topMargin = self.barInsets.top;
  CGFloat bottomMargin = self.barInsets.bottom;
  
  return (self.bounds.size.height - kDefaultPadding * 2.0F - topMargin - bottomMargin) / self.comicImageView.image.size.height;
}

//The horizontal ratio of displayable area to content size.
- (CGFloat) widthRatio {
  return (self.bounds.size.width - kDefaultPadding * 2.0F) / self.comicImageView.image.size.width;
}

//Update minimumZoomScale, maximumZoomScale, and starting zoomScale.
- (void) updateZoomLevels {
  
  CGFloat widthRatio = [self widthRatio];
  CGFloat heightRatio = [self heightRatio];
  
  //Minimum
  CGFloat minimumZoomScale = MIN(widthRatio, heightRatio);
  minimumZoomScale = MIN(1, minimumZoomScale);
  self.minimumZoomScale = minimumZoomScale;

  //Maximum
  CGFloat maximumZoomScale = MAX(widthRatio, heightRatio);
  maximumZoomScale = MAX(1.5, maximumZoomScale); //max zoom should be >= 1.5
  self.maximumZoomScale = maximumZoomScale;
  
  //Zoom to fit
  self.zoomScale = minimumZoomScale;
}

//Add content insets to center content horizonally.
- (void) centerContent {
  UIEdgeInsets insets = UIEdgeInsetsMake(kDefaultPadding,
                                         kDefaultPadding,
                                         kDefaultPadding + self.barInsets.top + self.barInsets.bottom,
                                         kDefaultPadding);
  
  //Add left inset if content is smaller than displayable width to center it.
  CGFloat contentScale = [self widthRatio];
  if (self.zoomScale < contentScale) {
    CGFloat left = ((self.bounds.size.width) - self.zoomScale * self.comicImageView.image.size.width) / 2.0F;
    insets.left = left;
  }
  
  self.contentInset = insets;
}

- (CGRect) zoomRectWithPoint:(CGPoint)point scale:(CGFloat)scale {
  CGFloat boundsWidth = self.bounds.size.width;
  CGFloat boundsHeight = self.bounds.size.height;
  
  //current zoom contentSize
  CGFloat contentWidth = self.contentSize.width / self.zoomScale;
  CGFloat contentHeight = self.contentSize.height / self.zoomScale;
  CGSize contentSize = CGSizeMake(contentWidth, contentHeight);

  //translate zoom point to content
  point.x = (point.x / boundsWidth) * contentSize.width;
  point.y = (point.y / boundsHeight) * contentSize.height;
  
  //zoom size
  CGFloat zoomWidth = boundsWidth / scale;
  CGFloat zoomHeight = boundsHeight / scale;
  CGSize zoomSize = CGSizeMake(zoomWidth, zoomHeight);

  //zoom rect
  CGFloat zoomX = point.x - zoomSize.width / 2.0F;
  CGFloat zoomY = point.y - zoomSize.height / 2.0F;
  CGRect zoomRect = CGRectMake(zoomX, zoomY, zoomWidth, zoomHeight);
  
  return zoomRect;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  [self centerContent];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.comicImageView;
}

@end
