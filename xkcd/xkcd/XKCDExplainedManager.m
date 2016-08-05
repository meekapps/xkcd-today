//
//  XKCDExplainedManager.m
//  xkcd
//
//  Created by Mike Keller on 8/4/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "XKCDExplainedManager.h"

//http://www.explainxkcd.com/wiki/api.php?action=query&format=json&export&generator=alllinks&pageids=15650
static NSString *const kXKCDExplainedUrl = @"http://www.explainxkcd.com/wiki/index.php";

@implementation XKCDExplainedManager

- (void) explain {
  NSURLSession *session = [NSURLSession sharedSession];
  

  NSString *comicIndex = @"890";
  NSString *urlString = [NSString stringWithFormat:@"%@/%@", kXKCDExplainedUrl, comicIndex];
  NSURL *url = [NSURL URLWithString:urlString];
  
  __weak typeof(self) weakSelf = self;
  NSURLSessionDataTask *task =
  [session dataTaskWithURL:url
         completionHandler:^(NSData * _Nullable data,
                             NSURLResponse * _Nullable response,
                             NSError * _Nullable error) {
           if (!error && data) {
             NSLog(@"IM GERE");
             [weakSelf processData:data];
           } else {
             [weakSelf processError:error];
           }
         }];
  [task resume];
}

#pragma mark - Private

- (void) processData:(NSData*)data {
  NSLog(@"JAHSDFK");
  NSError *jsonError = nil;
  id json = [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingAllowFragments
                                              error:&jsonError];
  
  NSLog(@"json: %@", json);
}

- (void) processError:(NSError*)error {
  //TODO: handle error
}

@end
