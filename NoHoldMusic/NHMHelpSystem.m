//
//  NHMHelpSystem.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/11/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import "NHMHelpSystem.h"
#import "NHMHelpWindow.h"

@interface NHMHelpSystem ()

@property NHMHelpWindow *helpWindow;
@end


@implementation NHMHelpSystem

+ (id)sharedHelpSystem
{
    static dispatch_once_t pred;
    static NHMHelpSystem *helpSystem = nil;

    dispatch_once(&pred, ^{ helpSystem = [[self alloc] init]; });
    return helpSystem;
}

- (IBAction)showHelpWindow:(nullable id)sender {
    NHMHelpWindow *newWin = [[NHMHelpWindow alloc] init];
    if (newWin) {
        self.helpWindow = newWin;
        [newWin showWindow:sender];
    }
}

@end
