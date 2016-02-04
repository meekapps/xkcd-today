//
//  FavoriteTableViewCell.h
//  xkcd
//
//  Created by Mike Keller on 2/3/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKCDComic.h"

@interface FavoriteTableViewCell : UITableViewCell

@property (weak, nonatomic) XKCDComic *comic;

@end
