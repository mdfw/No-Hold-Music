//
//  NHMHelpBook.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/1/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//


#import "NHMHelpBook.h"
#import "NoHoldMusicConstants.h"

@interface NHMHelpBook ()
@property (readwrite) BOOL isSearchable;
@property (readwrite) NSURL *indexFilePathURL;

@end

@implementation NHMHelpBook

- (instancetype)init {
    NSAssert(NO, @"init method is unavailable");
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
    NSURL *infoplistURL = [bookDirPathURL URLByAppendingPathComponent:@"info.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:bookDirPathURL.path]) {
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
            if ([propName hasSuffix:@"Path"]) {
                if (![propValue isKindOfClass:[NSString class]]) {
                    continue;
                }
                propValue = [self pathExtendedByBookDirPath:(NSString *)propValue];
            }
            [self setValue:propValue forKey:propName];
        }
    }
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
    if (!self.anchorsPlistPath) {
        return NO;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.anchorsPlistPath]) {
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
    if (!self.contentsListPlistPath) {
        return NO;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.contentsListPlistPath]) {
        return NO;
    }
    NSDictionary *contentsDict = [NSDictionary dictionaryWithContentsOfFile:self.contentsListPlistPath];
    if (contentsDict) {
        self.contentsList = contentsDict;
        return YES;
    }
    return NO;

}

@end


NSString *const NHMHelpBookErrorDomain = @"NHMHelpBookError";