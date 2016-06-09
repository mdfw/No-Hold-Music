//
//  NHMHelpContentController.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/4/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import "NHMHelpContentController.h"
#import "NHMHelpWindowConstants.h"
#import "NoHoldMusicConstants.h"
#import "NHMHelpManagerProtocols.h"
#import "NHMHelpWindowProtocols.h"
#import "NHMHelpWindowController.h"
#import "NHMHelpBook.h"

@interface NHMHelpContentController ()
@property NHMHelpBook *currentBook;
@end

@implementation NHMHelpContentController

- (BOOL)showIndexFileInBook:(nonnull NHMHelpBook *)book withHelpWindowController:(nonnull NHMHelpWindowController *)windowController {
    if (!book || !windowController) {
        return NO;
    }
    self.currentBook = book;
    windowController.contentDelegate = self;
    [windowController showAnchor:kNHMHelpBookIndexAnchor];
    return YES;
}

- (BOOL)showHelpAnchor:(nonnull NSString *)anchor inBook:(nonnull NHMHelpBook *)book withHelpWindowController:(nonnull NHMHelpWindowController *)windowController {
    windowController.contentDelegate = self;
    [windowController showAnchor:anchor];
    return YES;
}

#pragma mark - NHMHelpWindowContentProtocol
- (NHMHelpWindowContentType)contentTypeForAnchor:(nonnull NSString *)anchor {
    if ([anchor isEqualToString:kNHMHelpBookIndexAnchor]) {
        return [self contentTypeForIndexAnchor];
    }
    // TODO fix other anchors
    return NHMHelpWindowContentOther;
}

- (NHMHelpWindowContentType)contentTypeForIndexAnchor {
    if (self.currentBook.indexFilePath) {
        return NHMHelpWindowContentFilePath;
    } else if (self.currentBook.indexFileURL) {
        return NHMHelpWindowContentURL;
    }
    return NHMHelpWindowContentOther;
}

- (nonnull NHMHelpWindowURLContentResponse *)urlForAnchor:(nonnull NSString *)anchor {
    return [NHMHelpWindowURLContentResponse contentResponseWithURL:self.currentBook.indexFileURL];

}

- (nonnull NHMHelpWindowFilePathContentResponse *)pathForAnchor:(nonnull NSString *)anchor {
    return [NHMHelpWindowFilePathContentResponse contentResponseWithPath:self.currentBook.indexFilePath enclosingPath:self.currentBook.bookDirectoryPath];
}

@end
