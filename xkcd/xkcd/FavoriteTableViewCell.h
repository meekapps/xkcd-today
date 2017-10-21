//
//  FavoriteTableViewCell.h
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

@import UIKit;

@class XKCDComic;

@interface FavoriteTableViewCell : UITableViewCell

@property (weak, nonatomic) XKCDComic *comic;

@end
