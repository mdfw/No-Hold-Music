//
//  NSToolbar+NHMToolbar.m
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


#import "NSToolbar+NHMToolbar.h"

@implementation NSToolbar (NHMToolbar)


- (BOOL)nhm_isVisibleItemIdentifier:(NSString *)itemIdentifier {
    for (NSToolbarItem *item in self.visibleItems) {
        if ([item.itemIdentifier isEqualToString:itemIdentifier]) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)nhm_visibleIndexForItemIdentifier:(NSString *)itemIdentifier {
    NSInteger index = 0;
    for (NSToolbarItem *item in self.visibleItems) {
        if ([item.itemIdentifier isEqualToString:itemIdentifier]) {
            return index;
        } else {
            index++;
        }
    }
    return -1;
}



@end
