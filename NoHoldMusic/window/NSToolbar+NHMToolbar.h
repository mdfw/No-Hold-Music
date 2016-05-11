    //
//  NSToolbar+NHMToolbar.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/11/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSToolbar (NHMToolbar)

/**
 *  Is the toolbarItem identified by identifier in the visibleItems.
 *
 *  @param itemIdentifier The toolbarItem identifier.
 *
 *  @return If the item is in the visibleItems list, returns true.
 */
- (BOOL)nhm_isVisibleItemIdentifier:(NSString *)itemIdentifier;

/**
 *  Index of an item in the visibleItems list
 *
 *  @param itemIdentifier The toolbarItem identifier.
 *
 *  @return Index of the visible item or -1 if not found.
 */
- (NSInteger)nhm_visibleIndexForItemIdentifier:(NSString *)itemIdentifier;


@end
