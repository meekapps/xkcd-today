//
//  MainTitleView.h
//  xkcd
//
//  Created by Mike Keller on 2/25/18.
//  Copyright © 2018 meek apps. All rights reserved.
//

@import UIKit;

@class XKCDComic;

@interface MainTitleView : UIView

/// Designated initializer.
- (instancetype)initWithComic:(XKCDComic *)comic NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@property (weak, nonatomic) XKCDComic *comic;

@end
