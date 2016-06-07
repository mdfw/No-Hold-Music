//
//  NHMHelpBooks.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/6/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.


#import "NHMHelpBooks.h"
#import "NHMHelpBook.h"

@interface NHMHelpBooks ()
@property NSMutableArray *helpBooks;
@end

@implementation NHMHelpBooks

+ (nullable NSArray <NHMHelpBook *>*)allBooksInBundle:(nullable NSBundle *)bundle helpDirPath:(nullable NSString *)dirPath bookFileExtension:(nullable NSString*)extension {
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    if (!extension) {
        extension = @"help";
    }

    NSArray <NSURL *> *urls = [bundle URLsForResourcesWithExtension:extension subdirectory:dirPath];
    NSMutableArray *bookArray = [NSMutableArray array];
    for (NSURL *bookURL in urls) {
        NHMHelpBook *thisBook = [[NHMHelpBook alloc] initWithBookDirPathURL:bookURL error:nil];
        if (thisBook) {
            [bookArray addObject:thisBook];
        }
    }
    if (bookArray.count > 0) {
        return [bookArray copy];
    } else {
        return nil;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _helpBooks = [NSMutableArray array];
    }
    return self;
}

- (BOOL)registerBooksInBundle:(nonnull NSBundle *)bundle {
    NSArray *books = [NHMHelpBooks allBooksInBundle:bundle helpDirPath:nil bookFileExtension:nil];
    if (books && books.count > 0) {
        [self registerBooks:books];
        return YES;
    }
    return NO;
}

- (void)registerBooks:(NSArray<NHMHelpBook *> *)books {
    for (NHMHelpBook *book in books) {
        [self registerHelpBook:book];
    }
}

- (void)unregisterAllBooks {
    _helpBooks = [NSMutableArray array];
}

- (BOOL)registerHelpBook:(nonnull NHMHelpBook *)book {
    if (!book) {
        return NO;
    }
    if ([self bookIsRegistered:book]) {
        return NO;
    }
    [_helpBooks addObject:book];
    return YES;
}

- (NSArray *)registeredHelpBooks {
    return [_helpBooks copy];
}

/**
 *  Check if book is registered already.
 *
 *  @param book The book to check.
 *
 *  @return Return YES if the book is already registered.
 */
- (BOOL)bookIsRegistered:(nonnull NHMHelpBook *)book {
    for (NHMHelpBook *regbook in [self registeredHelpBooks]) {
        if ([regbook isEqualToHelpBook:book]) {
            return YES;
        }
    }
    return NO;
}

- (nullable NHMHelpBook *)bookForLanguage:(nullable NSString *)language {
    if (!self.helpBooks || self.helpBooks.count == 0) {
        return nil;
    }
    if (self.helpBooks.count == 1) {
        return [self.helpBooks objectAtIndex:0];
    }
    NHMHelpBook *book = [self localizedBookForLanguage:language];
    if (!book) {
        book = [self localizedBookForLanguage:[[NSLocale preferredLanguages] objectAtIndex:0]];
    }
    if (!book) {
        book = [self localizedBookForLanguage:self.defaultHelpBookLanguage];
    }
    if (!book) {
        book = [self.helpBooks objectAtIndex:0];
    }
    return book;
}

/**
 *  A private method to look for a book by language. Although it's marked nullable, if language is empty, it *always* returns nil.
 *
 *  @param language the language.
 *
 *  @return a Help book or nil if not found or if language is nil.
 */
- (nullable NHMHelpBook *)localizedBookForLanguage:(nullable NSString *)language {
    if (!language) {
        return nil;
    }
    for (NHMHelpBook *book in self.helpBooks) {
        if ([book.languages indexOfObject:language] != NSNotFound ) {
            return book;
        }
    }
    return nil;
}

@end
