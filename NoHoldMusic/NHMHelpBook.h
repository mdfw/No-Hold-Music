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
 *  The language of the book.
 */
@property (nullable) NSArray *languages;

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
 *  @note While this is technically not necessary, HelpContentController will look in this Dictionary for the anchor list and thus 'openAnchor' calls will fail.
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
 *  The version of the book.
 */
@property (nullable) NSString *bookVersion;

#pragma mark - init
/**
 *  Creates a Help book by looking in the path for an info.plist and calling initWithHelpBookInfoPathURL…
 *
 *  @param bookDirPathURL The directory path url for this book.
 *  @param error  error if nil.
 *
 *  @return An instance of NHMHelpBook or nil on error.
 *  @see initWithHepBookInfoPathURL:bookDirPathURL:error;
 */
- (nullable instancetype)initWithBookDirPathURL:(nonnull NSURL *)bookDirPathURL error:(NSError * _Nullable * _Nullable)error;

/**
 *  Creates a Help Book by parsing the info.plist passed in. Creates with initWithIndexPathURL then fills in properties from the plist.
 *  @see "NHMHelpBook info.plist keys"
 *
 *  @param infoPathURL The path to the info.plist.
 *  @param bookDirPathURL The path to the Book directory. If empty, the parent path to the info.plist will be used.
 *  @param error        Error.
 *
 *  @return An instance of NHMHelpBook or nil on error.
 */
- (nullable instancetype)initWithHelpBookInfoPathURL:(nonnull NSURL *)infoPathURL bookDirPathURL:(nullable NSURL *)bookDirPathURL error:(NSError * _Nullable * _Nullable)error;

/**
 *  Creates a help book with the minimum required syntax. 
 *  @note Designated initializer.
 *
 *  @param indexPathURL Path of the index file.
 *  @param bookDirPathURL The path to the Book directory. If empty, item is ignored.
 *  @param error        Error if nill
 *
 *  @return An instance of NHMHelpBook or nil on error (typically, the file isn't found).
 *  @warning This does not load any other files - it is the responsibility of the caller to set all properties besides indexPathURL and bookDirPathURL properties.
 */
- (nullable instancetype)initWithIndexPathURL:(nonnull NSURL *)indexPathURL  bookDirPathURL:(nullable NSURL *)bookDirPathURL error:(NSError * _Nullable * _Nullable)error;

#pragma mark - loaders
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

/**
 *  Is one help book equal to the other. 
 *  @warning This only compares the title, language array, path(s) and version variables. Does not compare the anchor list or contents.
 *
 *  @param book The book to compare this book against.
 *
 *  @return YES if the two books are equal.
 */
- (BOOL)isEqualToHelpBook:(nonnull NHMHelpBook *)book;

@end

#pragma mark - NHMHelpBook info.plist keys

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kNHMHelpBookTitlePlistKey; // NHMBookTitle
FOUNDATION_EXPORT NSString *const kNHMHelpBookLanguagesPlistKey; // NHMBookLanguages
FOUNDATION_EXPORT NSString *const kNHMHelpBookIndexFilePathPlistKey; // NHMBookIndexFilePath
FOUNDATION_EXPORT NSString *const kNHMHelpBookSearchIndexFilePathPlistKey; // NHMBookSearchIndexFilePath
FOUNDATION_EXPORT NSString *const kNHMHelpBookAnchorPlistFilePathPlistKey; // NHMBookAnchorsPlistFilePath
FOUNDATION_EXPORT NSString *const kNHMHelpBookContentsPlistFilePathPlistKey; // NHMBookContentsPlistFilePath
FOUNDATION_EXPORT NSString *const kNHMHelpBookVersionKey; // NHMBookVersion


#pragma mark - error codes

FOUNDATION_EXPORT NSString *const kNHMHelpBookErrorDomain;
typedef NS_ENUM(NSUInteger, NHMHelpBookErrorCodes) {
    NHMHelpBookErrorIndexFileNotFound = 1,
    NHMHelpBookErrorBookDirectoryNotFound = 2,
    NHMHelpBookErrorInfoFileNotFound = 3,
    NHMHelpBookErrorInfoDictionaryInvalid = 4,

};


NS_ASSUME_NONNULL_END
