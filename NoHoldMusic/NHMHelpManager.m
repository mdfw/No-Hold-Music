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


#import "NHMHelpManager.h"
#import "NHMHelpWindowController.h"

@interface NHMHelpManager ()

@property NSMutableArray *helpBooks;

@end


@implementation NHMHelpManager

+ (id)sharedHelpManager
{
    static dispatch_once_t pred;
    static NHMHelpManager *helpManager = nil;
    dispatch_once(&pred, ^{ helpManager = [[self alloc] init]; });
    return helpManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _helpBooks = [NSMutableArray array];
    }
    return self;
}
@end
