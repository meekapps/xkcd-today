//
//  XKCD.m
//  xkcd
//
//  Created by Mike Keller on 1/29/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

#import "AppDelegate.h"
#import "NSNumber+Operations.h"
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

- (void) moveFavoriteFromIndex:(NSUInteger)fromIndex
                       toIndex:(NSUInteger)toIndex {
  NSArray *favorites = [self fetchFavorites];
  
  BOOL moveDown = toIndex > fromIndex;
  NSUInteger minRow = MIN(fromIndex, toIndex);
  NSUInteger maxRow = MAX(fromIndex, toIndex);
  
  for (NSUInteger i = minRow; i <= maxRow; i++) {
    //move down, subtract, move up add.
    XKCDComic *thisComic = favorites[i];
    if (i == fromIndex) {
      thisComic.favorite = moveDown ? @(maxRow) : @(minRow);
    } else {
      thisComic.favorite = moveDown ? [thisComic.favorite subtract:1] : [thisComic.favorite add:1];
    }
  }
  
  [[PersistenceManager sharedManager] saveContext];
}

//Adds favorite to top of the list, or removes favorite. Adjusts favorite index for sorting.
- (void) toggleFavorite:(NSNumber *)index {
  XKCDComic *comic = [[XKCD sharedInstance] fetchComicWithIndex:index];
  BOOL adding = comic.favorite == nil;
  
  //Adjust existing favorite indices - add or subtract by one after this index
  NSArray *favorites = [self fetchFavorites];
  NSUInteger startingIndex = adding ? 0 : comic.favorite.unsignedIntegerValue + 1;
  for (NSUInteger i = startingIndex; i < favorites.count; i++) {
    XKCDComic *thisComic = favorites[i];
    //If removing this comic, subtract one from indices after this.
    //If adding, add one to indices after 0.
    thisComic.favorite = comic.favorite ? [thisComic.favorite subtract:1] : [thisComic.favorite add:1];
  }
  
  //If removing, clear this property, if adding, set to 0 (top of list).
  comic.favorite = comic.favorite ? nil : @(0);
  
  [[PersistenceManager sharedManager] saveContext];
}

- (NSArray<XKCDComic*>*) fetchFavorites {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XKCDComic"];
  request.predicate = [NSPredicate predicateWithFormat:@"favorite != nil"];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"favorite" ascending:YES];
  request.sortDescriptors = @[sortDescriptor];
  NSManagedObjectContext *context = [PersistenceManager sharedManager].managedObjectContext;
  NSError *error = nil;
  NSArray *results = [context executeFetchRequest:request
                                            error:&error];
  if (!results || error) return nil;
  
  return results;
}

- (XKCDComic*) fetchLatestComic {
  XKCDComic *comic = [self fetchComicWithIndex:nil];
  return comic;
}

- (XKCDComic*) fetchComicWithIndex:(NSNumber*)index {
  NSManagedObjectContext *managedObjectContext = [PersistenceManager sharedManager].managedObjectContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([XKCDComic class])
                                                       inManagedObjectContext:managedObjectContext];
  fetchRequest.entity = entityDescription;
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index"
                                                                 ascending:NO];
  fetchRequest.sortDescriptors = @[sortDescriptor];
  fetchRequest.fetchLimit = 1;

  //Fetch explicit index if argument is passed - fetches highest index (newest) otherwise.
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
    return nil;
  }
  
  XKCDComic *comic = fetchedObjects.firstObject;
  NSLog(@"fetched comic, %@", index ? index : @"latest");
  return comic;
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
  
  NSLog(@"getting comic with index: %@", index);
  
  NSString *urlString = [self comicUrlStringWithIndex:index];
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  __weak XKCD *weakSelf = self;
  [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                  completionHandler:^(NSData * _Nullable data,
                                                      NSURLResponse * _Nullable response,
                                                      NSError * _Nullable error) {
                                    [weakSelf unpackPayload:data
                                             completion:^(XKCDComic *comic) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                 [[SpotlightManager sharedManager] indexComic:comic];
                                                 NSLog(@"got comic from http, %@", index ? index : @"latest");
                                                 completion(comic);
                                               });
                                             }];
                                  }] resume];
  
//  return;
//  
//  NSURLSession *session = nil;
//  NSURLSessionConfiguration *backgroundSessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[self backgroundSessionIdentifier]];
//  backgroundSessionConfiguration.sharedContainerIdentifier = @"group.com.meekapps.xkcd";
//  session =  [NSURLSession sessionWithConfiguration:backgroundSessionConfiguration
//                                           delegate:self
//                                      delegateQueue:nil];
//  backgroundSessionConfiguration.sessionSendsLaunchEvents = YES;
//  backgroundSessionConfiguration.discretionary = YES;
//  backgroundSessionConfiguration.allowsCellularAccess = YES;
//  backgroundSessionConfiguration.timeoutIntervalForRequest = 15.0F;
//  backgroundSessionConfiguration.timeoutIntervalForResource = 15.0F;
//  
//  NSString *urlString = [self comicUrlStringWithIndex:index];
//  NSURL *url = [NSURL URLWithString:urlString];
//  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//  
//  NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];
//  self.completion = ^void(XKCDComic *comic) {
//    [session finishTasksAndInvalidate];
//    dispatch_async(dispatch_get_main_queue(), ^{
//      [[SpotlightManager sharedManager] indexComic:comic];
//      NSLog(@"got comic from http, %@", index ? index : @"latest");
//      completion(comic);
//    });
//  };
//  
//  [downloadTask resume];
  
}

//Returns comic with highest index.
- (NSNumber*) latestComicIndex {
  XKCDComic *comic = [self fetchLatestComic];
  if (!comic) return nil;
  
  return comic.index;
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
  
  //index
  id index = payload[@"num"];
  XKCDComic *comic = [[XKCD sharedInstance] fetchComicWithIndex:index];
  if (!comic) {
    NSManagedObjectContext *managedObjectContext = [PersistenceManager sharedManager].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([XKCDComic class])
                                                         inManagedObjectContext:managedObjectContext];
    comic = [[XKCDComic alloc] initWithEntity:entityDescription
               insertIntoManagedObjectContext:managedObjectContext];
  }
  
  if (index && [index isKindOfClass:[NSNumber class]]) comic.index = index;
  
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
