//
//  NSApplication+NHMHelpExtension.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/4/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//

#import "NSApplication+NHMHelpExtension.h"
#import "NHMHelpWindowController.h"
#import "NHMHelpManager.h"

@implementation NSApplication (NHMHelpExtension)

- (IBAction)nhm_showHelp:(nullable id)sender {
    [NHMHelpManager.sharedHelpManager openIndexFileInBook:nil];
}

@end
