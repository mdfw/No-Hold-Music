//
//  NHMHelpWindowTaskbarViewController.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/15/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//
/**
 *  NHMHelpWindowTaskbarViewController
 *  Help Window Toolbar that's not a toolbar, it's a view. Designed to be stuck
 *  to the bottom of the main title bar. Standard layout is:
 *  | index | back|forward | share |-- subtitle --| search | float |
 *
 */

#import <Cocoa/Cocoa.h>
#import "NHMHelpWindowConstants.h"


@interface NHMHelpWindowTaskbarViewController : NSTitlebarAccessoryViewController

// All outlet properties marked strong so we can remove/add them back to the view
//   hierarchy without worrying they will drop out of scope.

/**
 *  Popup button to show the index and bookmarked items.
 */
@property (strong, nullable) IBOutlet NSPopUpButton *indexPopUpButton;

/**
 *  Reverse in the stack
 */
@property (strong, nullable) IBOutlet NSButton *backButton;

/**
 *  Move forward in the stack.
 */
@property (strong, nullable) IBOutlet NSButton *forwardButton;

/**
 *  Share, print
 */
@property (strong, nullable) IBOutlet NSButton *shareButton;

/**
 *  A label, hidden by default to allow the title of the page to be displayed.
 */
@property (strong, nullable) IBOutlet NSTextField *subTitleLabel;

/**
 *  Search field.
 */
@property (strong, nullable) IBOutlet NSSearchField *searchField;

/**
 *  Allows the window to float.
 */
@property (strong, nullable) IBOutlet NSButton *floatButton;


/**
 *  Set the float toolbar image.
 *
 *  @param image The image for the toolbar.
 *  @param state The state to set the button image for.
 */
- (void)setFloatToolbarButtonImage:(NSImage * __nonnull)image forState:(NHMHelpWindowFloatState)state;

/**
 *  The current float toolbar button image. If it is custom set, will return that image, otherwise will return builtin image.
 *
 *  @param state The state requested.
 *
 *  @return Either the custom values or the built in.
 *  @warning Passing invalid state will result in the off state image returned.
 */
- (NSImage * __nonnull)floatToolbarButtonImageForState:(NHMHelpWindowFloatState)state;

/**
 *  Sets the state of the float window button. Uses the images above or the builtin balloon.
 *
 *  @param state The state for the button.
 *  @note If the button is not visible, does not affect anything.
 */
- (void)switchFloatToolbarButtonImageToState:(NHMHelpWindowFloatState)state;

@end
