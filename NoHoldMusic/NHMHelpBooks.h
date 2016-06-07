//
//  NHMHelpBooks.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/6/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NHMHelpBook;

@interface NHMHelpBooks : NSObject

/**
 *  Searches bundle for all help books.
 *
 *  @param bundle    The bundle to search. Defaults to bundle for this class.
 *  @param dirPath   Path to the subdirectory to search.
 *  @param extension The extension used for the help directories/bundles. Defaults to ".help"
 *
 *  @return An array of books or nil if none found.
 */
+ (nullable NSArray <NHMHelpBook *>*)allBooksInBundle:(nullable NSBundle *)bundle helpDirPath:(nullable NSString *)dirPath bookFileExtension:(nullable NSString*)extension;

/**
 *  Register one or mor help books in the given bundle. Calls allBooksInBundle:helpDirPath:bookFileExtension to find help book bundles ".help" then calls registerBooks:
 *
 *  @param bundle The bundle to look for help files.
 *
 *  @return Returns NO if no books are found in the bundle.
 */
- (BOOL)registerBooksInBundle:(nonnull NSBundle *)bundle;

/**
 *  Registers a set of help books for the help system.
 *
 *  @param books An array of helpBook objects.
 */
- (void)registerBooks:(nonnull NSArray <NHMHelpBook *>*)books;

/**
 *  Clears all registered books;
 */
- (void)unregisterAllBooks;

/**
 *  Register a help book. If book is already registered (as detected by isEqualToHelpBook), the book will not be registered.
 *
 *  @param book a NHMHelpBook object.
 *
 *  @return YES if book was registered.
 */
- (BOOL)registerHelpBook:(nonnull NHMHelpBook *)book;

/**
 *  The registered help books.
 *
 *  @return An array of registered help books.
 */
- (nonnull NSArray <NHMHelpBook *>*)registeredHelpBooks;

/**
 *  The default book if no other books match the language of the user.
 */
@property (nullable) NSString *defaultHelpBookLanguage;

/**
 *  Returns the book for the related language. If no language is passed in, an attempt to match the current user's language is made. If that fails, the defaultHelpBookLangauge is used. Finally, will return the first help book in registeredHelpBooks.
 *
 *  @param language The language of the book requested.
 *
 *  @return A book or nil if there are no help books.
 */
- (nullable NHMHelpBook *)bookForLanguage:(nullable NSString *)language;

@end
