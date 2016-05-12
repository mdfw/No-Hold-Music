//
//  NHMHelpWindowToolbar.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/11/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.


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
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
    BOOL success = [[[NSNib alloc] initWithNibNamed:@"NHMHelpWindowToolbar" bundle:classBundle] instantiateWithOwner:self topLevelObjects:&topLevelObjects];
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
    [self switchFloatToolbarButtonImageToState:NHMHelpWindowFloatStateOff];
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
        return [NHMFloatBalloonImage imageOfBalloonWithBalloonFillColor:[NSColor clearColor]];
    }
}

- (void)switchFloatToolbarButtonImageToState:(NHMHelpWindowFloatState)state {
    if ([self nhm_isVisibleItemIdentifier:kNHMToolbarItemIdentifierFloat]) {
            self.floatToolbarButton.image = [self floatToolbarButtonImageForState:state];
    }
}

@end
