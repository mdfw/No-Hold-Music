//
//  NHMHelpWindow.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/10/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NHMHelpWindowProtocols.h"

@class NHMHelpWindowToolbar;

@interface NHMHelpWindow : NSWindowController
/**
 *  Set to true to allow the window to float (and show the float window button)
 *  @note To change the image of the button, see the HMHelpWindowToolbar class.
 */
@property (nonatomic) BOOL allowFloatingWindow;

/**
 *  The Toolbar that shows on the help window.
 */
@property (weak, nullable) IBOutlet NHMHelpWindowToolbar *toolbar;

@end
