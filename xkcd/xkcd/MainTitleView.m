//
//  MainTitleView.m
//  xkcd
//
//  Created by Mike Keller on 2/25/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

#import "MainTitleView.h"
#import "NSDate+ShortDate.h"
#import "XKCDComic.h"

typedef NS_ENUM(NSUInteger, MainTitleViewState) {
  MainTitleViewTitleState = 0,
  MainTitleViewDateState = 1,
  MainTitleViewIndexState = 2,
};

@interface MainTitleView()
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic) MainTitleViewState state;
@end

@implementation MainTitleView

/// Designated initializer
- (instancetype)initWithComic:(XKCDComic *)comic {
  self = [super initWithFrame:CGRectMake(0.0F, 0.0F, 200.0F, 44.0F)];
  if (self) {
    _comic = comic;
    _state = MainTitleViewTitleState;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
  }
  return self;
}

- (UILabel *)titleLabel {
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18.0F];
    [self addSubview:_titleLabel];
  }
  return _titleLabel;
}

- (void)setComic:(XKCDComic *)comic {
  _comic = comic;
  [self updateTitle];
}

- (void)setState:(MainTitleViewState)state {
  [self updateTitle];
}

#pragma mark - Private

- (void) handleTap:(UITapGestureRecognizer *)tapRecognizer {
  self.state = self.state == MainTitleViewIndexState ? MainTitleViewTitleState : self.state + 1;
  [self updateTitle];
  // TODO fix this
}

- (void) updateTitle {
  switch (self.state) {
    case MainTitleViewTitleState:
      self.titleLabel.text = self.comic.title;
      break;
    case MainTitleViewDateState:
      self.titleLabel.text = [self.comic.date shortDate];
      break;
    case MainTitleViewIndexState:
      self.titleLabel.text = [NSString stringWithFormat:@"%@", self.comic.index];
      break;
    default:
      // Do nothing
      break;
  }
}

@end
