//
//  NSApplication+NHMHelpExtension.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/4/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSApplication (NHMHelpExtension)

/**
 *  Show the help window.
 *
 *  @param sender The object requesting the window.
 */
- (IBAction)nhm_showHelp:(nullable id)sender;

@end
