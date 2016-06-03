//
//  NHMHelpBook.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/1/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NHMHelpBook : NSObject

/**
 *  Title of the help window. Default is "Help".
 */
@property (nullable) NSString *bookTitle;

/**
 *  The path of the book directory.
 */
@property (nullable) NSString *bookDirectoryPath;

/**
 *  URL path of the index (start) html file.
 */
@property (nonnull, readonly) NSString *indexFilePath;

/**
 *  URL path of the search index. 
 *  If nil, search is not possible.
 */
@property (nullable) NSString *searchIndexPath;

/**
 *  Path URL of the anchors plist.
 */
@property (nullable) NSString *anchorsPlistPath;

/**
 *  A set of anchors. 
 *  @note While this is technically not necessary, HelpManager will look in this Dictionary for the anchor list and thus 'openAnchor' calls will fail.
 */
@property (nullable) NSDictionary<NSString*, NSString*> *anchors;

/**
 *  Location of the Contents dictionary plist. 
 *  To load the actual contents, see loadContentsFromPlist.
 */
@property (nullable) NSString *contentsListPlistPath;

/**
 *  Contents are the items that show up in the pulldown on the left of the default help window.
 *  Default is a single menu item of "home".
 *  If this is set, it overrides the "home" option so "home" should be included.
 *  To load from plist, see loadContentsFromPlist;
 */
@property (nullable) NSDictionary<NSString*, NSString*> *contentsList;

/**
 *  Searches bundle for all help books.
 *
 *  @param bundle    The bundle to search. Defaults to main bundle.
 *  @param extension The extension used for the help directories/bundles. Defaults to ".help"
 *
 *  @return An array of books or nil if none found.
 */
+ (nullable NSArray *)allBooksInBundle:(nullable NSBundle *)bundle helpDirFileExtension:(nullable NSString*)extension;

/**
 *  Creates a Help book by looking in the path for an info.plist containing the keys below. 
 *  Then calls designated initalizer if the NHMHelpBookIndexFilePathPlistKey key is found.
 *
 *  @param bookDirPathURL The directory path url for this book.
 *  @param error  error if nil.
 *
 *  @return An instance of NHMHelpBook or nil on error (typically, the file isn't found).
 *  @note Called designated initializer and then sets all related properties.
 */
- (nullable instancetype)initWithBookDirPathURL:(nonnull NSURL *)bookDirPathURL error:(NSError **)error;

/**
 *  Creates a help book with the minimum required syntax.
 *
 *  @param indexPathURL Path of the index file.
 *  @param error        Error if nill
 *
 *  @return An instance of NHMHelpBook or nil on error (typically, the file isn't found).
 *  @warning This does not load any other files - it is your responsibility to set all properties.
 */
- (nullable instancetype)initWithIndexPathURL:(nonnull NSURL *)indexPathURL error:(NSError **)error NS_DESIGNATED_INITIALIZER;

/**
 *  Loads the anchors from the plist and sets them to the anchors property.
 *  Called automatically from initWithBookDirPathURL.
 */
- (BOOL)loadAnchorsFromPlist;

/**
 *  Loads the contentsList from the plist.
 *  Called automatically from initWithBookDirPathURL.
 */
- (BOOL)loadContentsDictionaryFromPlist;
@end

#pragma mark - info.plist keys

NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString *const kNHMHelpBookTitlePlistKey = @"HPDBookTitle";
FOUNDATION_EXPORT NSString *const kNHMHelpBookIndexFilePathPlistKey = @"HPDBookAccessPath";
FOUNDATION_EXPORT NSString *const kNHMHelpBookSearchIndexFilePathPlistKey = @"NHMBookSearchIndexFilePath";
FOUNDATION_EXPORT NSString *const kNHMHelpBookAnchorPlistFilePathPlistKey = @"NHMBookAnchorPlistFilePath";
FOUNDATION_EXPORT NSString *const kNHMHelpBookContentsPlistFilePathPlistKey = @"NHMBookContentPlistFilePath";


#pragma mark - error codes

FOUNDATION_EXPORT NSString *const kNHMHelpBookErrorDomain;
typedef NS_ENUM(NSUInteger, NHMHelpBookErrorCodes) {
    NHMHelpBookErrorIndexFileNotFound = 1,
    NHMHelpBookErrorBookDirectoryNotFound = 2,
    NHMHelpBookErrorInfoFileNotFound = 3,
    NHMHelpBookErrorInfoDictionaryInvalid = 4,

};


NS_ASSUME_NONNULL_END
