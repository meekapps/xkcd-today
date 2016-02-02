//
//  XKCD.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "AppDelegate.h"
#import "PersistenceManager.h"
#import "SpotlightManager.h"
#import "XKCD.h"

static NSString *const kBackgroundSessionIdentifier = @"com.meekapps.xkcd.backgroundSession";

static NSString *const kXKCDServerBase = @"https://xkcd.com/";
static NSString *const kXKCDComicExtention = @"info.0.json";

@interface XKCD()
@property (copy) XKCDComicCompletion completion;
@property (strong, readwrite, nonatomic) NSNumber *latestComicIndex;
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
  __weak XKCD *weakSelf = self;
  [self fetchComicWithIndex:nil
                 completion:^(XKCDComic *comic) {
                   if (!comic) {
                     NSLog(@"error fetching latest comic");
                   } else {
                     //update latest comic index
                     weakSelf.latestComicIndex = comic.index;
                     
                     NSLog(@"fetched latest comic (%@)", weakSelf.latestComicIndex);
                   }
                   
                   completion(comic);
                 }];
}

- (void) fetchComicWithIndex:(NSNumber*)index
                  completion:(XKCDComicCompletion)completion {
  NSManagedObjectContext *managedObjectContext = [PersistenceController sharedInstance].managedObjectContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([XKCDComic class])
                                                       inManagedObjectContext:managedObjectContext];
  fetchRequest.entity = entityDescription;
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index"
                                                                 ascending:NO];
  fetchRequest.sortDescriptors = @[sortDescriptor];
  fetchRequest.fetchLimit = 1;

  //Fetch explicit index if argument is passed - fetches highgest index (newest) otherwise.
  if (index) {
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"index == %@", index, nil];
  }
  
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
  NSLog(@"fetched comic with index (%@)", index);
  completion(comic);
}

- (void) getLatestComic:(void(^)(XKCDComic *comic))completion {
  __weak XKCD *weakSelf = self;
  [self getComicWithIndex:nil
               completion:^(XKCDComic *comic) {
                 if (comic) {
                   weakSelf.latestComicIndex = comic.index;
                 }
                 completion(comic);
               }];
}

- (void) getComicWithIndex:(NSNumber *)index
                completion:(XKCDComicCompletion)completion {
  
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
  
  NSString *urlString = [self comicUrlStringWithIndex:index];
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  
  NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
  self.completion = ^void(XKCDComic *comic) {
    [session finishTasksAndInvalidate];
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"got comic from http (%@)", index);
      [[SpotlightManager sharedManager] indexComic:comic];
      completion(comic);
    });
  };
  
  [downloadTask resume];
  
}

#pragma mark - NSURLSession Delegate

- (void) URLSession:(NSURLSession *)session
       downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
  
  NSData *data = [NSData dataWithContentsOfURL:location];
  __weak XKCD *weakSelf = self;
  [self unpackPayload:data
           completion:^(XKCDComic *comic) {
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

#pragma mark - Private

// Returns NSString URL for comic with index. Passing index = nil returns latest comic URL.
// e.g. no index: http://xkcd.com/info.0.json, index: http://xkcd.com/614/info.0.json,
- (NSString*) comicUrlStringWithIndex:(NSNumber*)index {
  NSString *optionalIndexComponent = index ? [NSString stringWithFormat:@"%@/", index] : @"";
  NSString *path = [NSString stringWithFormat:@"%@%@%@", kXKCDServerBase, optionalIndexComponent, kXKCDComicExtention];
  return path;
}

// com.meekapps.xkcd.backgroundSession.<UUID>
- (NSString*) backgroundSessionIdentifier {
  NSUUID *randomUuid = [NSUUID UUID];
  NSString *uuidString = [randomUuid UUIDString];
  NSString *identifier = [NSString stringWithFormat:@"%@.%@", kBackgroundSessionIdentifier, uuidString];
  return identifier;
}

// Unpacks payload NSData into XKCDComic object.
- (void) unpackPayload:(NSData*)data
            completion:(XKCDComicCompletion)completion {
  NSError *error = nil;
  id unpackedPayload = [NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions
                                                         error:&error];
  if (error || !unpackedPayload || ![unpackedPayload isKindOfClass:[NSDictionary class]]) {
    NSLog(@"error unpacking payload: %@", error);
    completion(nil);
    return;
  }
  
  XKCDComic *comic = [self createAndInsertComicWithPayload:unpackedPayload];
  completion(comic);
}

- (XKCDComic*) createAndInsertComicWithPayload:(NSDictionary*)payload {
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
  
  NSLog(@"Inserting XKCDComic into NSManagedObjectContext: %@", comic);
  
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
