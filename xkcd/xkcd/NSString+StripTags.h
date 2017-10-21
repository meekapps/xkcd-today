//
//  NSString+StripTags.h
//  xkcd
//
//  Created by Mike Keller on 8/7/16.
//  Copyright © 2016 meek apps. All rights reserved.
//

@import Foundation;

@interface NSString (StripTags)

/// Returns string with <p> tags converted to newlines.
- (NSString*) convertParagraphTagsToNewlines;

/// Removes any "[edit]" wiki text.
- (NSString*) stripEdits;

/// Returns plain string with HTML tags stripped out.
- (NSString*) stripTags;

/// Returns string trimmed before Explanation.
- (NSString*) trimStringBeforeExplanation;

@end
