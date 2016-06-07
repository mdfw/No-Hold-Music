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

+ (nonnull instancetype)sharedHelpManager;

/**
 *  Open the index file of the associated book.
 *
 *  @param book The book to use.
 *
 *  @return Did the index file open.
 */
- (BOOL)openIndexFileInBook:(nullable NHMHelpBook *)book;
- (BOOL)openHelpAnchor:(nonnull NSString *)anchor inBook:(nullable NHMHelpBook *)book;
- (BOOL)findString:(nonnull NSString *)query inBook:(nullable NHMHelpBook *)book;

- (BOOL)registerBooksInBundle:(nonnull NSBundle *)bundle reset:(BOOL)reset;

@end
