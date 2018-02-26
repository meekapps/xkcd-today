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

typedef NS_ENUM(NSUInteger, MainTitleAnimationDirection) {
  MainTitleAnimationDirectionNone,
  MaintitleAnimationDirectionDown,
  MaintitleAnimationDirectionUp,
};

typedef NS_ENUM(NSUInteger, MainTitleViewState) {
  MainTitleViewTitleState,
  MainTitleViewDateState,
  MainTitleViewIndexState,
};

static CFTimeInterval const kAnimationDuration = 0.3;
static CGFloat const kMainTitleViewDefaultFontSize = 17.0F;
static NSTimeInterval const kTitleTimerDuration = 3.0;

@interface MainTitleView()
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic) MainTitleViewState state;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation MainTitleView

/// Designated initializer
- (instancetype)initWithComic:(XKCDComic *)comic {
  self = [super initWithFrame:CGRectMake(0.0F, 0.0F, 200.0F, 44.0F)];
  if (self) {
    _comic = comic;
    _state = MainTitleViewTitleState;
    self.clipsToBounds = YES;
    
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:kMainTitleViewDefaultFontSize];
    [self addSubview:_titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
  }
  return self;
}

- (void)setComic:(XKCDComic *)comic {
  _comic = comic;
  self.state = MainTitleViewTitleState;
  [self updateTitle];
  [self invalidateTimerIfNeeded];
}

- (void)setState:(MainTitleViewState)state {
  _state = state;
  [self updateTitle];
}

#pragma mark - Private

- (void) addTimerIfNeeded {
  [self invalidateTimerIfNeeded];
  
  if (self.state == MainTitleViewTitleState) return;
  
  self.timer = [NSTimer scheduledTimerWithTimeInterval:kTitleTimerDuration
                                                target:self
                                              selector:@selector(resetStateFromTimer:)
                                              userInfo:nil
                                               repeats:NO];
}

- (void) handleTap:(UITapGestureRecognizer *)tapRecognizer {
  self.state = self.state == MainTitleViewIndexState ? MainTitleViewTitleState : self.state + 1;
  [self updateTitleAnimationDirection:MaintitleAnimationDirectionDown];
  [self addTimerIfNeeded];
}

- (void) invalidateTimerIfNeeded {
  if (self.timer.isValid) {
    [self.timer invalidate];
  }
}

- (void) resetStateFromTimer:(NSTimer *)timer {
  self.state = MainTitleViewTitleState;
  
  [self updateTitleAnimationDirection:MaintitleAnimationDirectionUp];
}

- (void) updateTitle {
  [self updateTitleAnimationDirection:MainTitleAnimationDirectionNone];
}

- (void) updateTitleAnimationDirection:(MainTitleAnimationDirection)animationDirection {
  switch (self.state) {
    case MainTitleViewTitleState:
      self.titleLabel.text = self.comic.title;
      break;
    case MainTitleViewDateState:
      self.titleLabel.text = [self.comic.date shortDate];
      break;
    case MainTitleViewIndexState:
      self.titleLabel.text = [NSString stringWithFormat:@"# %@", self.comic.index];
      break;
    default:
      // Do nothing
      break;
  }
  
  if (animationDirection != MainTitleAnimationDirectionNone) {
    CATransition *transition = [CATransition animation];
    transition.duration = kAnimationDuration;
    transition.type = kCATransitionPush;
    transition.subtype = animationDirection == MaintitleAnimationDirectionDown ? kCATransitionFromBottom : kCATransitionFromTop;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.titleLabel.layer addAnimation:transition forKey:@"slide"];
  }
}

@end
