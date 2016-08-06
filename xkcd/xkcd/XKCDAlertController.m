//
//  XKCDAlertController.m
//  xkcd
//
//  Created by Mike Keller on 4/9/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "XKCDAlertController.h"
#import "XKCDExplained.h"
#import "XKCD.h"

static NSString *const kDefaultAlertMessage = @"Unable to load comic. Show in browser?";

@implementation XKCDAlertController

+ (instancetype) blacklistAlertControllerWithComic:(XKCDComic*)comic {
  
  NSString *messageString = comic.title ?
  [NSString stringWithFormat:@"This app is not %@ enabled. Show in browser?", comic.title] :
  kDefaultAlertMessage;
  
  return [self alertControllerWithMessage:messageString
                                    index:comic.index];
}

+ (instancetype) imageErrorAlertControllerWithComic:(XKCDComic *)comic {
  
  NSString *messageString = kDefaultAlertMessage;
  
  return [self alertControllerWithMessage:messageString
                                    index:comic.index];
}

#pragma mark - Private

+ (instancetype) alertControllerWithMessage:(NSString*)messageString
                                      index:(NSNumber*)index {
  NSString *titleString = @"Error -41";
  XKCDAlertController *blacklistAlert = [XKCDAlertController alertControllerWithTitle:titleString
                                                                              message:messageString
                                                                       preferredStyle:UIAlertControllerStyleAlert];
  NSString *noString = @"No";
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:noString
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                       }];
  [blacklistAlert addAction:cancelAction];
  
  NSString *playString = @"Play";
  UIAlertAction *playAction = [UIAlertAction actionWithTitle:playString
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                       NSURL *url = [XKCDAlertController blacklistComicUrlWithIndex:index];
                                                       [[UIApplication sharedApplication] openURL:url];
                                                     }];
  [blacklistAlert addAction:playAction];
  return blacklistAlert;
}

+ (NSURL*) blacklistComicUrlWithIndex:(NSNumber*)index {
  NSString *urlString = [NSString stringWithFormat:@"%@%@", kXKCDServerBase, index];
  NSURL *url = [NSURL URLWithString:urlString];
  return url;
}

@end
