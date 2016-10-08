//
//  MessagesViewController.m
//  xkcd message
//
//  Created by Mike Keller on 10/7/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "MessagesViewController.h"
#import "NSNumber+Operations.h"
#import "XKCD.h"

@interface MessagesViewController ()
@property (strong, nonatomic) XKCDComic *currentComic;
@property (strong, nonatomic) MSConversation *activeConversation;
@end

@implementation MessagesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
}

#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
  self.activeConversation = conversation;
  
  //Fetch most recent persisted comic from Core Data.
  __weak typeof(self) weakSelf = self;
  XKCDComic *fetchedComic = [[XKCD sharedInstance] fetchComicWithIndex:nil];
  
  if (fetchedComic) {
    weakSelf.currentComic = fetchedComic;
    [weakSelf updateViewsWithComic:fetchedComic];
    
    [weakSelf loadLatestWithCompletion:^{}];
  }
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
  self.activeConversation = nil;
}

#pragma mark - IBActions

- (IBAction) shareAction:(id)sender {
  if (!self.activeConversation) return;
  
  NSData *data = self.currentComic.image;
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths.firstObject;
  NSString *imagePath = [NSString stringWithFormat:@"%@/image.png", documentsDirectory];
  
  BOOL didWrite = [data writeToFile:imagePath atomically:YES];
  if (!didWrite) return;
  
  NSString *fullPath = [NSString stringWithFormat:@"file:///%@", imagePath];
  
  NSURL *url = [NSURL URLWithString:fullPath];
  NSString *title = self.currentComic.title;
  
  NSError *error = nil;
  MSSticker *sticker = [[MSSticker alloc] initWithContentsOfFileURL:url
                                               localizedDescription:title
                                                              error:&error];
  if (error) return;
  
  [self.activeConversation insertSticker:sticker
                       completionHandler:^(NSError * _Nullable error) {}];
  
}

#pragma mark - Private

- (void) loadLatestWithCompletion:(void(^)(void))completion {
  
  //GET latest comic from HTTP request, update UI if it is new.
  __weak typeof(self) weakSelf = self;
  [[XKCD sharedInstance] getComicWithIndex:nil
                                completion:^(XKCDComic *httpComic) {
                                  
                                  //no comic, fail
                                  if (!httpComic) {
                                    completion();
                                    return;
                                  }
                                  
                                  //new comic
                                  if (![weakSelf.currentComic.index equals:httpComic.index]) {
                                    weakSelf.currentComic = httpComic;
                                    [weakSelf updateViewsWithComic:httpComic];
                                  }
                                  completion();
                                }];
}

- (void) updateViewsWithComic:(XKCDComic*)comic {
  //Title
  NSString *title = comic.title;
  if (title) {
    self.titleLabel.text = title;
  }
  
  //Image
  NSData *cachedImageData = comic.image;
  if (cachedImageData) {
    UIImage *cachedImage = [UIImage imageWithData:cachedImageData];
    if (cachedImage) {
      self.imageView.image = cachedImage;
      return;
    }
  }
  
  //Image
  __weak typeof(self) weakSelf = self;
  [comic getImage:^(UIImage * _Nonnull image) {
    weakSelf.imageView.image = image;
  }];
}

@end
