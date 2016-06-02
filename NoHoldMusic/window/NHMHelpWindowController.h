//
//  NHMHelpWindow.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/10/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NHMHelpWindowTaskbarViewController.h"

@class NHMHelpWindowToolbar;

@interface NHMHelpWindowController : NSWindowController

/**
 *  Set to true to allow the window to float (and show the float window button)
 *  @note To change the image of the button, see the NHMHelpWindowToolbar class.
 */
@property (nonatomic) BOOL floatable;

/**
 *  The Toolbar that shows on the help window. This is *not* a subclass of NSToolbar,
 *  it's a subclass of NSView. For more information, see class header.
 *  @note Even if this controller exists, it may not be showing. see showTaskbar.
 */
@property (readonly, strong, nonnull) NHMHelpWindowTaskbarViewController *taskbarController;

/**
 *  Show or hide the taskbar. Hiding the taskbar will not unload the taskbar.
 */
@property (nonatomic) BOOL showTaskbar;

@end
