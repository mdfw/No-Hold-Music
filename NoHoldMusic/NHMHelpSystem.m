//
//  NHMHelpSystem.m
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
