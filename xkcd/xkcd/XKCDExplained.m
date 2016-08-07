//
//  XKCDExplained.m
//  xkcd
//
//  Created by Mike Keller on 8/4/16.
//  Copyright © 2016 Perka. All rights reserved.
//

#import "NSError+Message.h"
#import "NSString+StripTags.h"
#import "XKCDExplained.h"
#import "XKCDComic.h"

static NSString *const kExplainUrl = @"http://www.explainxkcd.com/wiki/index.php";
static NSString *const kExplainApiUrl = @"http://www.explainxkcd.com/wiki/api.php?action=parse&format=json&redirects&prop=text&section=1&page=";
static NSInteger const kXKCDExplainedErrorCode = 3333;
static NSString *const kXKCDExplainedParseKey = @"parse";
static NSString *const kXKCDExplainedTextKey = @"text";
static NSString *const kXKCDExplainedWildcardKey = @"*";

@implementation XKCDExplained

+ (void) explain:(XKCDComic*)comic completion:(XKCDExplainedCompletion)completion {
  NSNumber *page = comic.index;
  NSString *apiUrl = [NSString stringWithFormat:@"%@%@", kExplainApiUrl, page];
  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURL *url = [NSURL URLWithString:apiUrl];
  
  __weak typeof(self) weakSelf = self;
  NSURLSessionDataTask *request = [session dataTaskWithURL:url
                                         completionHandler:^(NSData * _Nullable data,
                                                             NSURLResponse * _Nullable response,
                                                             NSError * _Nullable error) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                             //Success
                                             if (data && !error) {
                                               [weakSelf handleSuccess:data completion:completion];
               
                                               //Error
                                             } else {
                                               [weakSelf handleError:error completion:completion];
                                             }
                                           });
                                         }];
  [request resume];
}

+ (void) openExplanationInSafari:(XKCDComic*)comic {
  NSNumber *comicIndex = comic.index;
  NSString *explainUrl = [NSString stringWithFormat:@"%@/%@", kExplainUrl, comicIndex];
  NSURL *url = [NSURL URLWithString:explainUrl];
  [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Private

+ (NSError*) errorWithMessage:(NSString*)message {
  NSString *domain = NSStringFromClass(self.class);
  NSError *error = [NSError errorWithDomain:domain
                                       code:kXKCDExplainedErrorCode
                                    message:message];
  return error;
}

+ (void) handleSuccess:(NSData*)data
            completion:(XKCDExplainedCompletion)completion {
  
  //No data, complete with error.
  if (!data) {
    NSError *noDataError = [self errorWithMessage:@"No Data."];
    [self handleError:noDataError
           completion:completion];
    return;
  }
  
  //Serialize JSON
  NSError *jsonError = nil;
  id json = [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingAllowFragments
                                              error:&jsonError];
  //JSON serialization error
  if (jsonError || !json) {
    [self handleError:jsonError
           completion:completion];
    return;
  }
  
  //Expecting an NSDictionary
  if ([json isKindOfClass:[NSDictionary class]] == NO) {
    NSError *jsonClassError = [self errorWithMessage:@"Expected class NSDictionary"];
    [self handleError:jsonClassError
           completion:completion];
    return;
  }
  
  //Expecting "parse" section
  id parseSection = json[kXKCDExplainedParseKey];
  if (!parseSection || [parseSection isKindOfClass:[NSDictionary class]] == NO) {
    NSError *parseSectionError = [self errorWithMessage:@"Expected 'parse' section."];
    [self handleError:parseSectionError
           completion:completion];
    return;
  }
  
  //Expecting "text" section
  id textSection = parseSection[kXKCDExplainedTextKey];
  if (!textSection || [textSection isKindOfClass:[NSDictionary class]] == NO) {
    NSError *textSectionError = [self errorWithMessage:@"Expected 'text' section."];
    [self handleError:textSectionError
           completion:completion];
    return;
  }
  
  //Expecting "*" section
  id explanationHtml = textSection[kXKCDExplainedWildcardKey];
  if (!explanationHtml || [explanationHtml isKindOfClass:[NSString class]] == NO) {
    NSError *wildcardError = [self errorWithMessage:@"Expected '*' section."];
    [self handleError:wildcardError
           completion:completion];
    return;
  }
  
  NSString *sanitized = [self sanitizedStringFromHtml:explanationHtml];
  
  //Success, complete
  completion(sanitized, nil);
}

+ (void) handleError:(NSError*)error
          completion:(XKCDExplainedCompletion)completion {
  
  //Complete with existing NSError
  if (error) {
    completion(nil, error);
    return;
  }
  
  //No NSError, make one.
  error = [self errorWithMessage:@"Unknown error."];
  completion(nil, error);
}

+ (NSString*) sanitizedStringFromHtml:(NSString*)htmlString {
  NSString *string = [htmlString convertParagraphTagsToNewlines];
  string = [string stripTags];
  string = [string stripEdits];
  string = [string trimStringBeforeExplanation];
  return string;
}

@end
