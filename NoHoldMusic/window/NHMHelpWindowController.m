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

#import "NHMHelpWindowController.h"
#import "NHMHelpWindowProtocols.h"
@import WebKit;

@interface NHMHelpWindowController ()

@property (strong, nonnull) NHMHelpWindowTaskbarViewController *taskbarController;

@property (weak) IBOutlet NSView *myMainView;
@property (weak) IBOutlet NSView *boxView;
@property NSView *contentView;
@end

@implementation NHMHelpWindowController

- (id)init {
    self = [super initWithWindowNibName:@"NHMHelpWindowController"];
    if (self) {
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.showTaskbar = YES;
    self.floatable = YES;
    [self testWebsite];
}


// BEGIN TESTING
- (void)testWebsite {
    WKWebView *webview = [[WKWebView alloc] init];
    self.contentView = webview;
    [webview setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.myMainView addSubview: webview];
    // align webview from the left and right
    [self.myMainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webview)]];

    // align webview from the top and bottom
    [self.myMainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webview)]];

    [webview loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://stackoverflow.com/questions/35418862/how-to-configure-a-wkwebview-to-fill-an-nswindow/35566479"]]];
    //[webview loadHTMLString:@"<html><body bgcolor=red><p>Hello, World!</p></body></html>" baseURL: nil];
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webview addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"Progress: %@", @(webview.estimatedProgress));

}

- (void)testWebsite2 {
    NSView *newView = [[NSView alloc] initWithFrame:self.myMainView.frame];
    newView.wantsLayer = YES;
    newView.layer.backgroundColor = [[NSColor redColor] CGColor];
    [newView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.contentView = newView;
    [self.myMainView addSubview:newView];
    [self.myMainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[newView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(newView)]];

     [self.myMainView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(newView)]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"ovserver");
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"progress update: %@", @([(WKWebView*)self.contentView estimatedProgress]));
        NSLog(@"Views: %@", self.myMainView.subviews);
    } else if ([keyPath isEqualToString:@"canGoBack"]) {
        NSLog(@"Can go back");
    }
}

// END TESTING

#pragma mark - taskbar
/**
 *  Load the taskbar and set sensible defaults. Does not add the taskbar to the window. 
 */
- (void)loadTaskbarController {
    NHMHelpWindowTaskbarViewController *taskbarC = [[NHMHelpWindowTaskbarViewController alloc] init];
    self.taskbarController = taskbarC;
    taskbarC.layoutAttribute = NSLayoutAttributeBottom;
    taskbarC.floatButton.target = self;
    taskbarC.floatButton.action = @selector(floatButtonPressed:);
    taskbarC.shareButton.target = self;
    taskbarC.shareButton.action = @selector(showSharingPicker:);
    [taskbarC.shareButton sendActionOn:NSLeftMouseDownMask];
    taskbarC.shareButton.enabled = NO;
    [taskbarC switchFloatToolbarButtonImageToState:NHMHelpWindowFloatStateOff];
}

- (void)setShowTaskbar:(BOOL)showTaskbar {
    if (!self.taskbarController) {
        [self loadTaskbarController];
    }
    NSInteger taskBarIndex = [self taskbarControllerIndexInWindow];
    if (showTaskbar) {
        if (taskBarIndex == NSNotFound) {
            [self.window addTitlebarAccessoryViewController:self.taskbarController];
        }
    } else {
        if (taskBarIndex != NSNotFound) {
            [self.window removeTitlebarAccessoryViewControllerAtIndex:taskBarIndex];
        }
    }
}

- (NSInteger)taskbarControllerIndexInWindow {
    NSInteger index = 0;
    for (NSTitlebarAccessoryViewController *accessoryC in self.window.titlebarAccessoryViewControllers) {
        if ([accessoryC isEqual:self.taskbarController]) {
            return index;
        }
        index = index + 1;
    }
    return NSNotFound;
}

- (void)setFloatable:(BOOL)allowFloatingWindow {
    _floatable = allowFloatingWindow;
    self.taskbarController.floatButton.hidden = !allowFloatingWindow;
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
    [self floatButton:sender On:floatButtonOn];
}

- (void)floatButton:(NSButton*)button On:(BOOL)on {
    if (on) {
        [self.taskbarController switchFloatToolbarButtonImageToState:NHMHelpWindowFloatStateOn];
    } else {
        [self.taskbarController switchFloatToolbarButtonImageToState:NHMHelpWindowFloatStateOff];
    }
}

- (IBAction)showSharingPicker:(id)sender {
    NSArray * items = @[@"bob's your uncle", @"James"];
    NSSharingServicePicker * picker = [[NSSharingServicePicker alloc] initWithItems:items];
    [picker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

@end