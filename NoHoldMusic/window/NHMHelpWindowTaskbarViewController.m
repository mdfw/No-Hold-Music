//
//  NHMHelpWindowTaskbarViewController.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/15/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import "NHMHelpWindowTaskbarViewController.h"
#import "NHMFloatBalloonImage.h"
#import "AvailabilityMacros.h"

@interface NHMHelpWindowTaskbarViewController ()
@property NSImage *floatImageOn;
@property NSImage *floatImageOff;

@end

@implementation NHMHelpWindowTaskbarViewController

- (id)init {
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
    self = [super initWithNibName:@"NHMHelpWindowTaskbarViewController" bundle:classBundle];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self switchFloatToolbarButtonImageToState:NHMHelpWindowFloatStateOff];
    self.searchField.recentsAutosaveName = [self nameUnderWhichToSaveRecentSearches];
}

- (NSString *)nameUnderWhichToSaveRecentSearches {
    NSString *appName = [[NSProcessInfo processInfo] processName];
    if (appName && appName.length > 0) {
        return [NSString stringWithFormat:@"NoHoldMusic.%@.helpSearch.recents", appName];
    } else {
        return @"NoHoldMusic.helpSearch.recents";
    }
}
- (void)setFloatToolbarButtonImage:(NSImage *)image forState:(NHMHelpWindowFloatState)state {
    assert(state == NHMHelpWindowFloatStateOff || state == NHMHelpWindowFloatStateOn);

    if (!image) {
        return;
    }
    if (state == NHMHelpWindowFloatStateOff) {
        self.floatImageOff = image;
    } else if (state == NHMHelpWindowFloatStateOn) {
        self.floatImageOn = image;
    }
}

- (NSImage * __nonnull)floatToolbarButtonImageForState:(NHMHelpWindowFloatState)state {
    assert(state == NHMHelpWindowFloatStateOff || state == NHMHelpWindowFloatStateOn);

    if (state == NHMHelpWindowFloatStateOn) {
        if (self.floatImageOn) {
            return self.floatImageOn;
        } else {
            return [NHMFloatBalloonImage imageOfBalloonWithBalloonFillColor:[NSColor colorForControlTint:[NSColor currentControlTint]]];
        }
    }
    if (self.floatImageOff) {
        return self.floatImageOff;
    } else {
        return [NHMFloatBalloonImage imageOfBalloonWithBalloonFillColor:[NSColor clearColor]];
    }
}

- (void)switchFloatToolbarButtonImageToState:(NHMHelpWindowFloatState)state {
    self.floatButton.image = [self floatToolbarButtonImageForState:state];
}

@end
