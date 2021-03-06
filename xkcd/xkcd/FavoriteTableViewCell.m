//
//  FavoriteTableViewCell.m
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "FavoriteTableViewCell.h"
#import "NSDate+ShortDate.h"
#import "XKCDComic.h"

@interface FavoriteTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@end


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
  self.detailLabel.text = [NSString stringWithFormat:@"#%@ - %@", comic.index, comic.date.shortDate];

  __weak FavoriteTableViewCell *weakSelf = self;
  [comic getImage:^(UIImage * _Nonnull image) {
    weakSelf.previewImageView.image = image;
  }];
}

@end
