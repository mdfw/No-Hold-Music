//
//  AppDelegate.m
//  NoHoldMusicDemo
//
//  Created by Mark D. Freeman Williams on 5/11/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import "AppDelegate.h"
#import <NoHoldMusic/NoHoldMusic.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) NHMHelpSystem *helpSystem;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self loadHelpSystem];
    [self.helpSystem showHelpWindow:nil];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)showHelpWindow:(id)sender {
    [self loadHelpSystem];
    [self.helpSystem showHelpWindow:sender];
}

- (void)loadHelpSystem {
    if (self.helpSystem) {
        return;
    }
    self.helpSystem = [NHMHelpSystem sharedHelpSystem];
}
@end
