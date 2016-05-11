//
//  NHMHelpWindow.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/10/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import "NHMHelpWindow.h"
#import "NHMHelpWindowProtocols.h"
#import "NHMHelpWindowToolbar.h"

@interface NHMHelpWindow ()
@property (weak) IBOutlet NSSegmentedControl *toolbarNavButtons;
@property (weak) IBOutlet NSSearchField *toolbarSearchField;
@property (weak) IBOutlet NSButton *toolbarShareButton;

@end

@implementation NHMHelpWindow

- (id)init {
    self = [super initWithWindowNibName:@"NHMHelpWindow"];
    if (self) {
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self setAllowFloatingWindow:YES];
}

- (void)setAllowFloatingWindow:(BOOL)allowFloatingWindow {
    _allowFloatingWindow = allowFloatingWindow;
    [self.toolbar showFloatToolbarItem:allowFloatingWindow];
}

- (IBAction)floatButtonPressed:(id)sender {
    BOOL floatButtonOn = NO;
    if (self.window.level == NSFloatingWindowLevel) {
        self.window.level = NSNormalWindowLevel;
        floatButtonOn = NO;
    } else {
        self.window.level = NSFloatingWindowLevel;
        floatButtonOn = YES;
    }
    if ([sender isKindOfClass:[NSButton class]]) {
        [self floatButton:sender On:floatButtonOn];
    }
}

- (void)floatButton:(NSButton*)button On:(BOOL)on {
    if (on) {
        [self.toolbar switchFloatToolbarButtonImageToState:NHMHelpWindowFloatStateOn];
    } else {
        [self.toolbar switchFloatToolbarButtonImageToState:NHMHelpWindowFloatStateOff];
    }
}


- (IBAction)shareButtonPressed:(id)sender {
}


@end
