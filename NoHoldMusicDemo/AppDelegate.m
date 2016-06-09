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
@property (weak) NHMHelpManager *helpManager;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self showNHMHelp:nil];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)showNHMHelp:(id)sender {
    [self loadHelpSystem];
    [[NSApplication sharedApplication] nhm_showHelp:sender];
}

- (void)loadHelpSystem {
    if (self.helpManager) {
        return;
    }
    self.helpManager = [NHMHelpManager sharedHelpManager];
}
@end
