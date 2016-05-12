//
//  NHMHelpWindow.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/10/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.

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
    [self loadToolbar];
    [self setAllowFloatingWindow:YES];

}

- (void)loadToolbar;
{
    NHMHelpWindowToolbar *helpToolbar = [NHMHelpWindowToolbar helpWindowToolbar];
    if (helpToolbar) {
        helpToolbar.floatToolbarButton.action = @selector(setAllowFloatingWindow:);
        helpToolbar.floatToolbarButton.target = self;
        helpToolbar.shareToolbarButton.target = self;
        helpToolbar.shareToolbarButton.action = @selector(showSharingPicker:);
        [helpToolbar.shareToolbarButton sendActionOn:NSLeftMouseDownMask];
        helpToolbar.shareToolbarButton.enabled = NO;
        self.toolbar = helpToolbar;
    }
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

- (IBAction)showSharingPicker:(id)sender {
    NSArray * items = @[@"bob's your uncle", @"James"];
    NSSharingServicePicker * picker = [[NSSharingServicePicker alloc] initWithItems:items];
    [picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

@end
