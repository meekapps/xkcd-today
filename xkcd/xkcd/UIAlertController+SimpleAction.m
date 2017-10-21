//
//  UIAlertController+SimpleAlert.m
//  xkcd
//
//  Created by Mike Keller on 2/6/16.
//  Copyright © 2016 meek apps. All rights reserved.
//
//  Simple UIAlertControllerStyleActionSheet UIAlertController with one ok button, and one cancel button.

#import "UIAlertController+SimpleAction.h"

@implementation UIAlertController (SimpleAction)

+ (instancetype) alertControllerWithOkButtonTitle:(NSString*)title
                                  okButtonHandler:(void(^)(void))okHandler {
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
  
  UIAlertAction *oldestAction = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                         if (okHandler) okHandler();
                                                       }];
  [alertController addAction:oldestAction];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                       }];
  [alertController addAction:cancelAction];
  
  return alertController;
}

@end
