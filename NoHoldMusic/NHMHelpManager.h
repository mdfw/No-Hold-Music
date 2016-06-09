//
//  NHMHelpSystem.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/11/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHMHelpManagerProtocols.h"

@class NHMHelpWindowController;
@class NHMHelpBooks;
@class NHMHelpBook;

@interface NHMHelpManager : NSObject

@property (nonnull) NHMHelpBooks *helpBooks;
@property (nullable) NHMHelpWindowController *helpWindowController;
@property (nonnull) id <NHMHelpManagerContentProtocol> contentController;
@property (nonnull) id <NHMHelpManagerSearchProtocol> searchController;

/**
 *  A shared help manager. Calls sharedHelpManagerWithWindowController:contentController:searchController: with default values.
 *
 *  @return The help manager.
 */
+ (nonnull instancetype)sharedHelpManager;

/**
 *  The shared help manager.
 *
 *  @param windowController  The windowController to use. If nil, will create one.
 *  @param contentController An object conforming to NHMHelpManagerContentProtocol. If nil, will create one.
 *  @param searchController  An object conforming to NHMHelpManagerSearchProtocol. If nil, will create one.
 *
 *  @return A fully formed helpManager.
 */
+ (nonnull instancetype)sharedHelpManagerWithWindowController:(nullable NHMHelpWindowController *)windowController
                                            contentController:(nullable id <NHMHelpManagerContentProtocol>)contentController
                                             searchController:(nullable id <NHMHelpManagerSearchProtocol>)searchController;

/**
 *  Creates a help manager. This is used by the sharedHelpManager class methods which should be used instead.
 *
 *  @param windowController  The windowController to use. If nil, will create one.
 *  @param contentController An object conforming to NHMHelpManagerContentProtocol. If nil, will create one.
 *  @param searchController  An object conforming to NHMHelpManagerSearchProtocol. If nil, will create one.
 *
 *  @return A help manager.
 */
- (nonnull instancetype)initWithWindowController:(nullable NHMHelpWindowController *)windowController contentController:(nullable id <NHMHelpManagerContentProtocol>)contentController searchController:(nullable id <NHMHelpManagerSearchProtocol>) searchController NS_DESIGNATED_INITIALIZER;


/**
 *  Open the index file of the associated book.
 *
 *  @param book The book to use. If nil, attempts to discover the default book.
 *
 *  @return Did the index item open.
 *  @note This calls openHelpAnchor... with the kNHMHelpBookIndexAnchor as the anchor.
 */
- (BOOL)openIndexFileInBook:(nullable NHMHelpBook *)book;

/**
 *  Opens a specific anchor in the associated book.
 *
 *  @param anchor The anchor to open.
 *  @param book The book to use. If nil, attempts to discover the default book.
 *
 *  @return Did the anchor open.
 */
- (BOOL)openHelpAnchor:(nonnull NSString *)anchor inBook:(nullable NHMHelpBook *)book;

/**
 *  Finds a specific string and opens the list in the help viewer.
 *
 *  @param query query string
 *  @param book  The book to use.
 *
 *  @return Was the search action successful.
 *  @warning NOT currently implemented.  // FIXME
 */
- (BOOL)findString:(nonnull NSString *)query inBook:(nullable NHMHelpBook *)book;


/**
 *  Registers books. If books are registered already, reset must be passed as YES to look for new books.
 *
 *  @param bundle The bundle.
 *  @param reset  YES if you want the system to look for new books.
 *
 *  @return Was registration successful.
 */
- (BOOL)registerBooksInBundle:(nonnull NSBundle *)bundle reset:(BOOL)reset;

@end
