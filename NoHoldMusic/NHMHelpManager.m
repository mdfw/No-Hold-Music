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
#import "NHMHelpBook.h"
#import "NHMHelpBooks.h"
#import "NHMHelpManagerProtocols.h"
#import "NHMHelpContentController.h"
#import "NHMHelpSearchController.h"


@interface NHMHelpManager ()
@property BOOL haveRegisteredBooks;
@end


@implementation NHMHelpManager

+ (id)sharedHelpManager {
    return [NHMHelpManager sharedHelpManagerWithWindowController:nil contentController:nil searchController:nil];
}

+ (nonnull instancetype)sharedHelpManagerWithWindowController:(nullable NHMHelpWindowController *)windowController contentController:(nullable id <NHMHelpManagerContentProtocol>)contentController searchController:(nullable id <NHMHelpManagerSearchProtocol>) searchController {
    static dispatch_once_t pred;
    static NHMHelpManager *helpManager = nil;
    dispatch_once(&pred, ^{ helpManager = [[self alloc] initWithWindowController:nil contentController:nil searchController:nil]; });
    return helpManager;
}

- (instancetype)init {
    return [self initWithWindowController:nil contentController:nil searchController:nil];
}
- (nonnull instancetype)initWithWindowController:(nullable NHMHelpWindowController *)windowController contentController:(nullable id <NHMHelpManagerContentProtocol>)contentController searchController:(nullable id <NHMHelpManagerSearchProtocol>) searchController {
    self = [super init];
    if (self) {
        _haveRegisteredBooks = NO;
        _helpBooks = [[NHMHelpBooks alloc] init];
        if (windowController) {
            _helpWindowController = windowController;
        } else {
            [self loadHelpWindow];
        }
        if (contentController) {
            _contentController = contentController;
        } else {
            _contentController = [[NHMHelpContentController alloc] init];
        }
        if (searchController) {
            _searchController = searchController;
        } else {
            _searchController = [[NHMHelpSearchController alloc] init];
        }
    }
    return self;
}

- (void)loadHelpWindow {
    if (!_helpWindowController) {
        _helpWindowController = [[NHMHelpWindowController alloc] init];
    }
}

- (BOOL)openIndexFileInBook:(nullable NHMHelpBook *)book {
    [self loadHelpWindow];
    [self registerBooksInBundle:[NSBundle mainBundle] reset:NO];
    if (!book) {
        book = [self.helpBooks bookForLanguage:nil];
    }
    if (book) {
        if (self.contentController && [self.contentController respondsToSelector:@selector(showIndexFileInBook:withHelpWindowController:)]) {
            return [self.contentController showIndexFileInBook:book withHelpWindowController:self.helpWindowController];
        }
    }
    return NO;
}

- (BOOL)openHelpAnchor:(nonnull NSString *)anchor inBook:(nullable NHMHelpBook *)book {
    if (!anchor) {
        // TODO: Error here
        return NO;
    }
    [self loadHelpWindow];
    [self registerBooksInBundle:[NSBundle mainBundle] reset:NO];
    if (!book) {
        book = [self.helpBooks bookForLanguage:nil];
    }
    if (book) {
        if (self.contentController && [self.contentController respondsToSelector:@selector(showHelpAnchor:inBook:withHelpWindowController:)]) {
            return [self.contentController showHelpAnchor:anchor inBook:book withHelpWindowController:self.helpWindowController];
        }
    }
    return NO;
}

- (BOOL)findString:(nonnull NSString *)query inBook:(nullable NHMHelpBook *)book {
    if (!query) {
        // TODO: Error here
        return NO;
    }
    [self loadHelpWindow];
    [self registerBooksInBundle:[NSBundle mainBundle] reset:NO];
    if (!book) {
        book = [self.helpBooks bookForLanguage:nil];
    }
    if (book) {
        if (self.searchController && [self.searchController respondsToSelector:@selector(showSearchString:inBook:withHelpWindowController:)]) {
            return [self.searchController showSearchString:query inBook:book withHelpWindowController:self.helpWindowController];
        }
    }
    return NO;
}


- (BOOL)registerBooksInBundle:(nonnull NSBundle *)bundle reset:(BOOL)reset {
    if (reset) {
        [self.helpBooks unregisterAllBooks];
    }
    if (self.haveRegisteredBooks && !reset) {
        return YES;
    }
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    return [self.helpBooks registerBooksInBundle:bundle];
}


@end
