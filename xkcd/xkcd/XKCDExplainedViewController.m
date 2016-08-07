//
//  XKCDExplainedViewController.m
//  xkcd
//
//  Created by Mike Keller on 8/7/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "XKCDExplainedViewController.h"
#import "XKCDExplained.h"

@interface XKCDExplainedViewController()
@property (copy, nonatomic) NSString *explanation;
@end

@implementation XKCDExplainedViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  
  [self explainComic:self.comic];
}

#pragma mark - Actions

- (IBAction) closeAction:(id)sender {
  [self.navigationController dismissViewControllerAnimated:YES
                                                completion:^{}];
}

#pragma mark - Private

- (void) explainComic:(XKCDComic*)comic {
  __weak typeof(self) weakSelf = self;
  [XKCDExplained explain:comic
              completion:^(NSString *explanation, NSError *error) {
                weakSelf.explanation = explanation;
              }];
}

- (void) setExplanation:(NSString *)explanation {
  _explanation = explanation;
  
  //TODO: update view with explanation.
  
  
}

@end
