//
//  NHMHelpBook.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/1/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.


#import "NHMHelpBook.h"
#import "NoHoldMusicConstants.h"

@interface NHMHelpBook ()
@property (readwrite) BOOL isSearchable;
@property (readwrite) NSURL *indexFilePathURL;

@end

@implementation NHMHelpBook

+ (nullable NSArray <NHMHelpBook *>*)allBooksInBundle:(nullable NSBundle *)bundle helpDirPath:(nullable NSString *)dirPath bookFileExtension:(nullable NSString*)extension {
    if (!bundle) {
        bundle = [NSBundle bundleForClass:[self class]];
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

- (nullable instancetype)init {
    NSAssert(NO, @"NHMHelpBook cannot be initialized with -init");
    self = [self initWithIndexPathURL:[NSURL URLWithString:@"none"] error:nil];
    return nil;
}

- (nullable instancetype)initWithBookDirPathURL:(NSURL *)bookDirPathURL error:(NSError **)error {
    NSParameterAssert(bookDirPathURL);
    if (![[NSFileManager defaultManager] fileExistsAtPath:bookDirPathURL.path]) {
        if (error) {
            *error = [NSError errorWithDomain:kNHMHelpBookErrorDomain code:NHMHelpBookErrorBookDirectoryNotFound userInfo:@{NSLocalizedDescriptionKey:NSLocalizedStringFromTable(@"helpBookDirectoryNotfound", kNHMLocalizedStringsTableName, @"Help book Direcotry not found.")}];
            return nil;
        }
    }

    _bookDirectoryPath = bookDirPathURL.path;
    NSDictionary *infoDict = [self loadInfoDictInDirectoryURL:bookDirPathURL error:error];

    if (!infoDict) {
        return nil;
    }

    NSString *indexFilePathComponent = [self indexFilePathComponentFromInfoDict:infoDict error:error];
    if (!indexFilePathComponent) {
        return nil;
    }

    NSURL *indexPathURL = [bookDirPathURL URLByAppendingPathComponent:indexFilePathComponent];
    if (!indexPathURL) {
        return nil;
    }
    self = [self initWithIndexPathURL:indexPathURL error:error];
    if (self) {
        [self fillPropertiesFromInfoDictionary:infoDict];
        [self loadAnchorsFromPlist];
        [self loadContentsDictionaryFromPlist];
    }
    return self;
}

- (nullable instancetype)initWithIndexPathURL:(NSURL *)indexPathURL error:(NSError **)error {
    NSParameterAssert(indexPathURL);

    if (![[NSFileManager defaultManager] fileExistsAtPath:indexPathURL.path]) {
        if (error) {
            *error = [NSError errorWithDomain:kNHMHelpBookErrorDomain code:NHMHelpBookErrorIndexFileNotFound userInfo:@{NSLocalizedDescriptionKey:NSLocalizedStringFromTable(@"helpBookIndexFileNotfound", kNHMLocalizedStringsTableName, @"Help book index file not found.")}];
            return nil;
        }
    }

    self = [super init];
    if (self) {
        _indexFilePathURL = indexPathURL;
        _bookTitle = NSLocalizedStringFromTable(@"helpBookTitle", kNHMLocalizedStringsTableName, @"Help");
    }

    return self;
}

- (NSDictionary *)loadInfoDictInDirectoryURL:(NSURL *)bookDirPathURL error:(NSError **)error {
    return [self loadInfoDictInDirectoryURL:bookDirPathURL fileManager:[NSFileManager defaultManager] error:error];
}

/**
 *  Loads the Information Dictionary in the given Book directory. Looks for a file called 'info.plist' in passed in directory URL.
 *
 *  @param bookDirPathURL The path of the help book directory.
 *  @param fileManager    NSFIleManager to use. Passed in to allow for testing.
 *  @param error          Any error.
 *
 *  @return An info dictionary or nil on failure.
 */
- (NSDictionary *)loadInfoDictInDirectoryURL:(NSURL *)bookDirPathURL fileManager:(NSFileManager*)fileManager error:(NSError **)error {
    NSURL *infoplistURL = [bookDirPathURL URLByAppendingPathComponent:@"info.plist"];
    NSParameterAssert(fileManager);

    if (![fileManager fileExistsAtPath:bookDirPathURL.path]) {
        if (error) {
            *error = [NSError errorWithDomain:kNHMHelpBookErrorDomain code:NHMHelpBookErrorInfoFileNotFound userInfo:@{NSLocalizedDescriptionKey:NSLocalizedStringFromTable(@"helpBookInformationFileNotFound", kNHMLocalizedStringsTableName, @"Help book info file not found.")}];
            return nil;
        }
    }
    NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfURL:infoplistURL];
    return infoDict;
}

- (NSString *)indexFilePathComponentFromInfoDict:(NSDictionary *)infoDict error:(NSError **)error {
    NSString *indexFilePath = [infoDict objectForKey:kNHMHelpBookIndexFilePathPlistKey];

    if (!indexFilePath || indexFilePath.length == 0) {
        if (error) {
            *error = [NSError errorWithDomain:kNHMHelpBookErrorDomain code:NHMHelpBookErrorInfoDictionaryInvalid userInfo:@{NSLocalizedDescriptionKey:NSLocalizedStringFromTable(@"helpBookInformationDictionaryInvalid", kNHMLocalizedStringsTableName, @"Help book invalid.")}];
            return nil;
        }
    }
    return indexFilePath;
}

- (void)fillPropertiesFromInfoDictionary:(nonnull NSDictionary *)dict {
    for (NSString *key in dict.allKeys) {
        NSString *propName = [self propertyNameForInfoDictKey:key];
        if (propName) {
            id propValue = [dict valueForKey:key];
            id newPropValue = [self extendPropValue:propValue withBookDirPathIfPathInPropName:propName];
            [self setValue:newPropValue forKey:propName];
        }
    }
}

- (id)extendPropValue:(nonnull id)propValue withBookDirPathIfPathInPropName:(NSString *)propName {
    NSString *newPropValue = propValue;
    if ([propName hasSuffix:@"Path"]) {
        if ([propValue isKindOfClass:[NSString class]]) {
            newPropValue = [self pathExtendedByBookDirPath:(NSString *)propValue];
        }
    }
    return newPropValue;
}

- (NSString *)pathExtendedByBookDirPath:(nonnull NSString *)oldPath {
    if (!self.bookDirectoryPath) {
        return oldPath;
    }
    NSURL *newURL = [[NSURL fileURLWithPath:self.bookDirectoryPath isDirectory:YES] URLByAppendingPathComponent:oldPath];
    return [newURL path];
}

- (NSString *)propertyNameForInfoDictKey:(NSString *)key {
    if ([key isEqualToString:kNHMHelpBookTitlePlistKey]) {
        return NSStringFromSelector(@selector(bookTitle));
    }
    if ([key isEqualToString:kNHMHelpBookIndexFilePathPlistKey]) {
        return NSStringFromSelector(@selector(indexFilePath));
    }
    if ([key isEqualToString:kNHMHelpBookSearchIndexFilePathPlistKey]) {
        return NSStringFromSelector(@selector(searchIndexPath));
    }
    if ([key isEqualToString:kNHMHelpBookAnchorPlistFilePathPlistKey]) {
        return NSStringFromSelector(@selector(anchorsPlistPath));
    }
    if ([key isEqualToString:kNHMHelpBookContentsPlistFilePathPlistKey]) {
        return NSStringFromSelector(@selector(contentsListPlistPath));
    }
    return nil;
}

- (BOOL)loadAnchorsFromPlist {
    return [self loadAnchorsFromPlistFileManager:[NSFileManager defaultManager]];
}

- (BOOL)loadAnchorsFromPlistFileManager:(NSFileManager *)fileManager {
    if (!self.anchorsPlistPath) {
        return NO;
    }
    if (![fileManager fileExistsAtPath:self.anchorsPlistPath]) {
        return NO;
    }
    NSDictionary *anchorDict = [NSDictionary dictionaryWithContentsOfFile:self.anchorsPlistPath];
    if (anchorDict) {
        self.anchors = anchorDict;
        return YES;
    }
    return NO;
}

- (BOOL)loadContentsDictionaryFromPlist {
    return [self loadContentsDictionaryFromPlistFileManager:[NSFileManager defaultManager]];
}

- (BOOL)loadContentsDictionaryFromPlistFileManager:(NSFileManager *)fileManager {
    if (!self.contentsListPlistPath) {
        return NO;
    }
    if (![fileManager fileExistsAtPath:self.contentsListPlistPath]) {
        return NO;
    }
    NSDictionary *contentsDict = [NSDictionary dictionaryWithContentsOfFile:self.contentsListPlistPath];
    if (contentsDict) {
        self.contentsList = contentsDict;
        return YES;
    }
    return NO;

}

NSString *const kNHMHelpBookTitlePlistKey = @"HPDBookTitle";
NSString *const kNHMHelpBookIndexFilePathPlistKey = @"HPDBookAccessPath";
NSString *const kNHMHelpBookSearchIndexFilePathPlistKey = @"NHMBookSearchIndexFilePath";
NSString *const kNHMHelpBookAnchorPlistFilePathPlistKey = @"NHMBookAnchorPlistFilePath";
NSString *const kNHMHelpBookContentsPlistFilePathPlistKey = @"NHMBookContentPlistFilePath";

NSString *const kNHMHelpBookErrorDomain = @"NHMHelpBookError";

@end


