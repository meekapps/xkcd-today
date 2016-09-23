//
//  FavoriteTableViewCell.m
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "FavoriteTableViewCell.h"
#import "XKCDComic.h"

@implementation FavoriteTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void) setComic:(XKCDComic *)comic {
  self.titleLabel.text = comic.title;

  __weak FavoriteTableViewCell *weakSelf = self;
  [comic getImage:^(UIImage * _Nonnull image) {
    weakSelf.previewImageView.image = image;
  }];
  
}

@end
