//
//  UIAlertController+SimpleAction.h
//  xkcd
//
//  Created by Mike Keller on 2/6/16.
//  Copyright © 2016 Perka. All rights reserved.
//
//  Simple UIAlertControllerStyleActionSheet UIAlertController with one ok button, and one cancel button.

@import UIKit;

@interface UIAlertController (SimpleAction)

+ (instancetype) alertControllerWithOkButtonTitle:(NSString*)title
                                  okButtonHandler:(void(^)(void))okHandler;

@end
