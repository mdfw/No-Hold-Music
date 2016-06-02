//
//  NHMHelpBook.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/1/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NHMHelpBook : NSObject

@property (nullable) NSString *bookTitle;
@property (nonnull) NSURL *indexFilePathURL;
@property BOOL isSearchable;
@property (nullable) NSURL *searchIndexPathURL;
@property (nullable) NSDictionary *anchorDictionary;

/**
 *  Searches bundle for all help books.
 *
 *  @param bundle    The bundle to search. Defaults to main bundle.
 *  @param extension The extension used for the help directories/bundles. Defaults to ".help"
 *
 *  @return An array of books or empty array if none found.
 */
- (nullable NSArray *)allBooksInBundle:(nullable NSBundle *)bundle helpDirFileExtension:(nullable NSString*)extension;

@end

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const NHMHelpBookIndexFilePathPlistKey;
FOUNDATION_EXPORT NSString *const NHMHelpBookSearchIndexFilePathPlistKey;
FOUNDATION_EXPORT NSString *const NHMHelpBookAnchorPlistFilePathPlistKey;
FOUNDATION_EXPORT NSString *const NHMHelpBookTitlePlistKey;
NS_ASSUME_NONNULL_END
