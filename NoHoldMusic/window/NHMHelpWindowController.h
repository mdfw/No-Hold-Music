//
//  NHMHelpWindow.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/10/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NHMHelpWindowTaskbarViewController.h"
#import "NHMHelpWindowProtocols.h"

@class NHMHelpWindowToolbar;

@interface NHMHelpWindowController : NSWindowController

@property (nullable) id <NHMHelpWindowContentProtocol> contentDelegate;
@property (nullable) id <NHMHelpWindowTaskbarProtocol> taskbarDelegate;
@property (nullable) id <NHMHelpWindowSearchProtocol> searchDelegate;

/**
 *  The holding view of the window. While you can manipulate the subviews, it's better to use the contentView directly. Useful for getting frame size.
 */
@property (nonnull, readonly) IBOutlet NSView *mainView;

/**
 *  The content view of the window. It is fully immersed in the mainView. When you set this, any subviews of mainView are removed and this is inserted and fully abutted to the top,right,bottom, and left.
 *  If nil is passed, the contentView is cleared.
 */
@property (nullable, readonly, nonatomic) __kindof NSView *contentView;

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
-(void)showTaskbar:(BOOL)show;

/**
 *  Is the taskbar currently showing?
 *
 *  @return Visibility of the taskbar.
 */
- (BOOL)taskbarIsShowing;

/**
 *  Calls the NHMHelpWindowContentProtocol delegate with the anchor.
 *  Initally, it calls contentTypeForAnchor:anchor: then the appropriate item from there.
 *
 *  @param anchor The anchor for this item.
 */
- (void)showAnchor:(nonnull NSString *)anchor;
@end
