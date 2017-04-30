//
//  XKCDExplainedViewController.m
//  xkcd
//
//  Created by Mike Keller on 8/7/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "UIAlertController+SimpleAction.h"
#import "XKCDExplainedViewController.h"
#import "XKCDExplained.h"

static NSTimeInterval const kExplaintedTextViewAnimationDuration = 0.12;

@interface XKCDExplainedViewController()
@property (copy, nonatomic) NSString *explanation;
@property (nonatomic) BOOL hasError;
@property (nonatomic) BOOL loading;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loaderView;
@end

@implementation XKCDExplainedViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  
  [self explainComic:self.comic];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  [self updateTextViewInsets];
}

#pragma mark - Actions

- (IBAction) closeAction:(id)sender {
  [self.navigationController dismissViewControllerAnimated:YES
                                                completion:^{}];
}

- (IBAction) openInSafariAction:(id)sender {
  __weak typeof(self) weakSelf = self;
  UIAlertController *openInSafariViewController =
  [UIAlertController alertControllerWithOkButtonTitle:@"Open in Safari"
                                      okButtonHandler:^{
                                        [XKCDExplained openExplanationInSafari:weakSelf.comic];
                                      }];
  
  [self.navigationController presentViewController:openInSafariViewController
                                          animated:YES
                                        completion:^{
    // Do nothing/
  }];
}

#pragma mark - Private

- (void) explainComic:(XKCDComic*)comic {
  self.loading = YES;
  
  __weak typeof(self) weakSelf = self;
  [XKCDExplained explain:comic
              completion:^(NSString *explanation, NSError *error) {
                if (explanation && !error) {
                  weakSelf.explanation = explanation;
                  weakSelf.hasError = NO;
                } else {
                  weakSelf.hasError = YES;
                }
                weakSelf.loading = NO;
              }];
}

- (void) setHasError:(BOOL)hasError {
  _hasError = hasError;
  self.errorLabel.hidden = !hasError;
}

- (void) setExplanation:(NSString *)explanation {
  _explanation = explanation;
  
  self.textView.text = explanation;
  [UIView transitionWithView:self.textView
                    duration:kExplaintedTextViewAnimationDuration
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                  } completion:^(BOOL finished) {
                  }];
  
}

- (void) setLoading:(BOOL)loading {
  _loading = loading;
  if (loading) {
    self.hasError = NO;
    [self.loaderView startAnimating];
  } else {
    [self.loaderView stopAnimating];
  }
}

- (void) updateTextViewInsets {
  
  CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
  CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
  CGFloat insetTop = navBarHeight + statusBarHeight;
  
  //Text inset
  CGFloat padding = 8.0F;
  UIEdgeInsets textInsets = UIEdgeInsetsMake(insetTop + padding, padding, padding, padding);
  self.textView.textContainerInset = textInsets;
  
  //Scroll indicator
  UIEdgeInsets scrollInsets = UIEdgeInsetsMake(insetTop, 0.0F, 0.0F, 0.0F);
  self.textView.scrollIndicatorInsets = scrollInsets;
}

@end
