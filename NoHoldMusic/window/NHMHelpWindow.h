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

@property (nonatomic) BOOL allowFloatingWindow;
@property (weak, nullable) IBOutlet NHMHelpWindowToolbar *toolbar;

@end
