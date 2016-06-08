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
@property (readwrite) NSString *indexFilePath;
@property (readwrite) NSURL *indexFileExternalURL;

@end

@implementation NHMHelpBook

- (nullable instancetype)init {
    NSAssert(NO, @"NHMHelpBook cannot be initialized with -init. Use initWithIndexPathURL");
    return nil;
}

- (nullable instancetype)initWithBookDirPathURL:(NSURL *)bookDirPathURL error:(NSError **)error {
    return [self initWithBookDirPathURL:bookDirPathURL fileManager:[NSFileManager defaultManager] error:error];
}

- (nullable instancetype)initWithBookDirPathURL:(NSURL *)bookDirPathURL fileManager:(NSFileManager *)fileManager error:(NSError **)error {
    NSParameterAssert(bookDirPathURL);
    BOOL isDir;
    if (![fileManager fileExistsAtPath:bookDirPathURL.path isDirectory:&isDir] || !isDir) {
        if (error) {
            *error = [NSError errorWithDomain:kNHMHelpBookErrorDomain code:NHMHelpBookErrorBookDirectoryNotFound userInfo:@{NSLocalizedDescriptionKey:NSLocalizedStringFromTable(@"helpBookDirectoryNotfound", kNHMLocalizedStringsTableName, @"Help book Direcotry not found.")}];
            return nil;
        }
    }

    NSURL *infoDictFilePathURL = [bookDirPathURL URLByAppendingPathComponent:@"info.plist"];
    if (![fileManager fileExistsAtPath:infoDictFilePathURL.path]) {
        if (error) {
            *error = [NSError errorWithDomain:kNHMHelpBookErrorDomain code:NHMHelpBookErrorInfoFileNotFound userInfo:@{NSLocalizedDescriptionKey:NSLocalizedStringFromTable(@"helpBookInformationFileNotFound", kNHMLocalizedStringsTableName, @"Help book info file not found.")}];
            return nil;
        }
    }

    return [self initWithHelpBookInfoPathURL:infoDictFilePathURL bookDirPathURL:bookDirPathURL error:error];
}

- (nullable instancetype)initWithHelpBookInfoPathURL:(nonnull NSURL *)infoPathURL bookDirPathURL:(nullable NSURL *)bookDirPathURL error:(NSError * _Nullable * _Nullable)error {
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
    self = [self initWithIndexPathURL:indexPathURL bookDirPathURL:bookDirPathURL error:error];
    if (self) {
        [self fillPropertiesFromInfoDictionary:infoDict];
        [self loadAnchorsFromPlist];
        [self loadContentsDictionaryFromPlist];
    }
    return self;
}

- (nullable instancetype)initWithIndexPathURL:(nonnull NSURL *)indexPathURL bookDirPathURL:(nullable NSURL *)bookDirPathURL error:(NSError * _Nullable * _Nullable)error {
    NSParameterAssert(indexPathURL);

    if (![[NSFileManager defaultManager] fileExistsAtPath:indexPathURL.path]) {
        if (error) {
            *error = [NSError errorWithDomain:kNHMHelpBookErrorDomain code:NHMHelpBookErrorIndexFileNotFound userInfo:@{NSLocalizedDescriptionKey:NSLocalizedStringFromTable(@"helpBookIndexFileNotfound", kNHMLocalizedStringsTableName, @"Help book index file not found.")}];
            return nil;
        }
    }
    self = [super init];
    if (self) {
        _indexFilePath = indexPathURL.path;
        _bookDirectoryPath = bookDirPathURL.path;
        _bookTitle = NSLocalizedStringFromTable(@"helpBookTitle", kNHMLocalizedStringsTableName, @"Help");
    }
    return self;
}

- (nullable instancetype)initWithIndexURL:(nonnull NSURL *)indexExternalURL  bookDirPathURL:(nullable NSURL *)bookDirPathURL error:(NSError * _Nullable * _Nullable)error {
    NSParameterAssert(indexExternalURL);
    self = [super init];
    if (self) {
        _indexFileExternalURL = indexExternalURL;
        _bookDirectoryPath = bookDirPathURL.path;
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
        if ([key isEqualToString:kNHMHelpBookLanguagesPlistKey]) {
            self.languages = [dict objectForKey:key];
            continue;
        }
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
    if ([key isEqualToString:kNHMHelpBookLanguagesPlistKey]) {
        return NSStringFromSelector(@selector(languages));
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
    return [self loadAnchorsFromPlist:self.anchorsPlistPath FileManager:[NSFileManager defaultManager]];
}

- (BOOL)loadAnchorsFromPlist:(NSString *)plistPath FileManager:(NSFileManager *)fileManager {
    if (!plistPath) {
        return NO;
    }
    if (![fileManager fileExistsAtPath:plistPath]) {
        return NO;
    }
    NSDictionary *anchorDict = [self dictFromPlistPath:plistPath];
    if (anchorDict) {
        self.anchors = anchorDict;
        return YES;
    }
    return NO;
}

- (BOOL)loadContentsDictionaryFromPlist {
    return [self loadContentsDictionaryFromPlist:self.contentsListPlistPath fileManager:[NSFileManager defaultManager]];
}

- (BOOL)loadContentsDictionaryFromPlist:(NSString *)plistPath fileManager:(NSFileManager *)fileManager {
    if (!plistPath) {
        return NO;
    }
    if (![fileManager fileExistsAtPath:plistPath]) {
        return NO;
    }
    NSDictionary *contentsDict = [self dictFromPlistPath:plistPath];
    if (contentsDict) {
        self.contentsList = contentsDict;
        return YES;
    }
    return NO;
}

- (NSDictionary *)dictFromPlistPath:(NSString *)plistPath {
    if (!plistPath) {
        return nil;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if (dict && dict.count > 0) {
        return dict;
    }
    return nil;
}

#pragma mark - comparison
- (BOOL)isEqualToHelpBook:(nonnull NHMHelpBook *)book {
    if (![self.indexFilePath isEqualToString:book.indexFilePath]) {
        return NO;
    }
    if (![self.bookDirectoryPath isEqualToString:book.bookDirectoryPath]) {
        return NO;
    }
    if (![self.languages isEqual:book.languages]) {
        return NO;
    }
    if (![self.searchIndexPath isEqualToString:book.searchIndexPath]) {
        return NO;
    }
    if (![self.anchorsPlistPath isEqualToString:book.anchorsPlistPath]) {
        return NO;
    }
    if (![self.contentsListPlistPath isEqualToString:book.contentsListPlistPath]) {
        return NO;
    }
    if (![self.bookVersion isEqualToString:book.bookVersion]) {
        return NO;
    }
    return YES;
}


#pragma mark - NHMHelpBook info.plist keys

NSString *const kNHMHelpBookTitlePlistKey = @"NHMBookTitle";
NSString *const kNHMHelpBookLanguagesPlistKey = @"NHMBookLanguages";
NSString *const kNHMHelpBookIndexFilePathPlistKey = @"NHMBookIndexFilePath";
NSString *const kNHMHelpBookSearchIndexFilePathPlistKey = @"NHMBookSearchIndexFilePath";
NSString *const kNHMHelpBookAnchorPlistFilePathPlistKey = @"NHMBookAnchorsPlistFilePath";
NSString *const kNHMHelpBookContentsPlistFilePathPlistKey = @"NHMBookContentsPlistFilePath";
NSString *const kNHMHelpBookVersionKey = @"NHMBookVersion";

NSString *const kNHMHelpBookErrorDomain = @"NHMHelpBookError";

@end


