//
//  NHMHelpWindowToolbar.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/11/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//


#import "NHMHelpWindowToolbar.h"
#import "NSToolbar+NHMToolbar.h"
#import "NHMFloatBalloonImage.h"
#import "AvailabilityMacros.h"

NSString* const kNHMToolbarItemIdentifierFloat = @"float";
NSString* const kNHMToolbarItemIdentifierSearch = @"search";
NSString* const kNHMToolbarItemIdentifierShare = @"share";

@interface NHMHelpWindowToolbar ()
@property NSImage *floatImageOn;
@property NSImage *floatImageOff;

@end

@implementation NHMHelpWindowToolbar

+ (nullable instancetype)helpWindowToolbar {
    NSArray *topLevelObjects = nil;
    BOOL success = [[[NSNib alloc] initWithNibNamed:@"NHMHelpWindowToolbar" bundle:nil] instantiateWithOwner:self topLevelObjects:&topLevelObjects];
    if (success) {
        for (id item in topLevelObjects) {
            if ([item isKindOfClass:[NSToolbar class]]) {
                if ([item respondsToSelector:@selector(setUpHelpWindowToolbar)]) {
                    [item setUpHelpWindowToolbar];
                }
                return item;
            }
        }
    }
    return nil;
}

- (void)setUpHelpWindowToolbar {
#if (__MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_10)
    NSLog(@"We are bigger");
    _navigationToolbarSegmentedControl.segmentStyle = NSSegmentStyleSeparated;
#endif

}
- (void)showFloatToolbarItem:(BOOL)show {
    if (show && ![self nhm_isVisibleItemIdentifier:kNHMToolbarItemIdentifierFloat]) {
        [self insertItemWithItemIdentifier:kNHMToolbarItemIdentifierFloat atIndex:self.visibleItems.count];
    } else if (!show && [self nhm_isVisibleItemIdentifier:kNHMToolbarItemIdentifierFloat]) {
        [self removeItemAtIndex:[self nhm_visibleIndexForItemIdentifier:kNHMToolbarItemIdentifierFloat]];
    }
}

- (void)showShareToolbarItem:(BOOL)show {
    if (show && ![self nhm_isVisibleItemIdentifier:kNHMToolbarItemIdentifierShare]) {
        [self insertItemWithItemIdentifier:kNHMToolbarItemIdentifierShare atIndex:1];
    } else if (!show && [self nhm_isVisibleItemIdentifier:kNHMToolbarItemIdentifierShare]) {
        [self removeItemAtIndex:[self nhm_visibleIndexForItemIdentifier:kNHMToolbarItemIdentifierShare]];
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
        return [NHMFloatBalloonImage imageOfBalloonWithBalloonFillColor:[NSColor colorForControlTint:[NSColor currentControlTint]]];
    }
}

- (void)switchFloatToolbarButtonImageToState:(NHMHelpWindowFloatState)state {
    if ([self nhm_isVisibleItemIdentifier:kNHMToolbarItemIdentifierFloat]) {
            self.floatToolbarButton.image = [self floatToolbarButtonImageForState:state];
    }
}

@end
