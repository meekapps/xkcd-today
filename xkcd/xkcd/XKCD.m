//
//  XKCD.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "AppDelegate.h"
#import "PersistenceController.h"
#import "XKCD.h"

static NSString *const kBackgroundSessionIdentifier = @"net.meekapps.xkcd.backgroundSession";

static NSString *const kXKCDServerBase = @"https://xkcd.com/";
static NSString *const kXKCDComicExtention = @"info.0.json";

typedef void(^XKCDCompletionBlock)(XKCDComic *comic);

@interface XKCD()
@property (copy) XKCDCompletionBlock completion;
@property (nonatomic) BOOL loading;
@end

@implementation XKCD

+ (instancetype) sharedInstance {
  static dispatch_once_t onceToken;
  static XKCD *instance = nil;
  dispatch_once(&onceToken, ^{
    instance = [[XKCD alloc] init];
  });
  return instance;
}

- (void) fetchLatestComic:(void(^)(XKCDComic *comic))completion {
  NSManagedObjectContext *managedObjectContext = [PersistenceController sharedInstance].managedObjectContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([XKCDComic class])
                                                       inManagedObjectContext:managedObjectContext];
  fetchRequest.entity = entityDescription;
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                 ascending:NO];
  fetchRequest.sortDescriptors = @[sortDescriptor];
  
  NSError *error = nil;
  NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest
                                                                error:&error];
  if (!fetchedObjects ||
      error ||
      fetchedObjects.count == 0 ||
      ![fetchedObjects.firstObject isKindOfClass:[XKCDComic class]]) {
    
    NSLog(@"error fetching: %@", error);
    completion(nil);
    return;
  }
  
  XKCDComic *comic = fetchedObjects.firstObject;
  completion(comic);
}

- (void) getLatestComic:(void(^)(XKCDComic *comic))completion {
  NSLog(@"getting latest comic...");
  
  self.loading = YES;
  
  NSURLSession *session = nil;
  NSURLSessionConfiguration *backgroundSessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[self backgroundSessionIdentifier]];
  backgroundSessionConfiguration.sharedContainerIdentifier = @"group.com.meekapps.xkcd";
  session =  [NSURLSession sessionWithConfiguration:backgroundSessionConfiguration
                                           delegate:self
                                      delegateQueue:nil];
  backgroundSessionConfiguration.sessionSendsLaunchEvents = YES;
  backgroundSessionConfiguration.discretionary = YES;
  backgroundSessionConfiguration.allowsCellularAccess = YES;
  backgroundSessionConfiguration.timeoutIntervalForRequest = 15.0F;
  backgroundSessionConfiguration.timeoutIntervalForResource = 15.0F;
  
  NSString *urlString = [self comicUrlString];
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  
  NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
  self.completion = ^void(XKCDComic *comic) {
    [session finishTasksAndInvalidate];
    dispatch_async(dispatch_get_main_queue(), ^{
      completion(comic);
    });
  };
  
  [downloadTask resume];
}

- (void) setLoading:(BOOL)loading {
  _loading = loading;
  

}

#pragma mark - NSURLSession Delegate

- (void) URLSession:(NSURLSession *)session
       downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
  
  NSData *data = [NSData dataWithContentsOfURL:location];
  __weak XKCD *weakSelf = self;
  [self unpackPayload:data
           completion:^(XKCDComic *comic) {
             weakSelf.loading = NO;
             weakSelf.completion(comic);
  }];
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
       didWriteData:(int64_t)bytesWritten
  totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
  NSLog(@"did write data: %lld/%lld", bytesWritten, totalBytesExpectedToWrite);
}

- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
  if (error) {
    NSLog(@"completed download task, error: %@", error);
  }
}

- (void) URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
  if (error) {
    NSLog(@"session became invalid: %@", error);
  }
}

- (void) URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
  NSLog(@"session did finish");
  //TODO: app extension solution
//  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//  if (appDelegate.backgroundSessionCompletionHandler) {
//    void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
//    appDelegate.backgroundSessionCompletionHandler = nil;
//    completionHandler();
//  }
}


#pragma mark - Private

- (NSString*) comicUrlString {
  return [NSString stringWithFormat:@"%@%@", kXKCDServerBase, kXKCDComicExtention];
}

- (NSString*) backgroundSessionIdentifier {
  NSUUID *randomUuid = [NSUUID UUID];
  NSString *uuidString = [randomUuid UUIDString];
  NSString *identifier = [NSString stringWithFormat:@"%@.%@", kBackgroundSessionIdentifier, uuidString];
  return identifier;
}

- (void) unpackPayload:(NSData*)data completion:(XKCDCompletionBlock)completion {
  NSError *error = nil;
  id unpackedPayload = [NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions
                                                         error:&error];
  if (error || !unpackedPayload || ![unpackedPayload isKindOfClass:[NSDictionary class]]) {
    NSLog(@"error unpacking payload: %@", error);
    completion(nil);
    return;
  }
  
  NSLog(@"payload: %@", unpackedPayload);
  XKCDComic *comic = [self comicWithPayload:unpackedPayload];
  completion(comic);
}

- (XKCDComic*) comicWithPayload:(NSDictionary*)payload {
  NSManagedObjectContext *managedObjectContext = [PersistenceController sharedInstance].managedObjectContext;
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([XKCDComic class])
                                                       inManagedObjectContext:managedObjectContext];
  XKCDComic *comic = [[XKCDComic alloc] initWithEntity:entityDescription
                        insertIntoManagedObjectContext:managedObjectContext];
  
  //date
  id day = payload[@"day"];
  id month = payload[@"month"];
  id year = payload[@"year"];
  if (day && month && year) {
    comic.date = [self dateFromMonth:month day:day year:year];
  }
  
  //image url
  id imageUrl = payload[@"img"];
  if (imageUrl && [imageUrl isKindOfClass:[NSString class]]) comic.imageUrl = imageUrl;
  
  //index
  id index = payload[@"num"];
  if (index && [index isKindOfClass:[NSNumber class]]) comic.index = index;
  
  //title
  id title = payload[@"title"];
  if (title && [title isKindOfClass:[NSString class]]) comic.title = title;
  
  NSLog(@"Persisting XKCDComic: %@", comic);
  
  return comic;
}

- (NSDate*) dateFromMonth:(NSNumber*)month
                      day:(NSNumber*)day
                     year:(NSNumber*)year {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.month = month.integerValue;
  components.day = day.integerValue;
  components.year = year.integerValue;
  NSDate *date = [calendar dateFromComponents:components];
  return date;
}

@end
