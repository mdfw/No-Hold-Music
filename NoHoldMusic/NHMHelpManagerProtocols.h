//
//  NHMHelpManagerProtocols.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/5/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NHMHelpBook;
@class NHMHelpWindowController;

@protocol NHMHelpManagerContentProtocol <NSObject>

- (BOOL)showIndexFileInBook:(nonnull NHMHelpBook *)book withHelpWindowController:(nonnull NHMHelpWindowController *)windowController;
- (BOOL)showHelpAnchor:(nonnull NSString *)anchor inBook:(nonnull NHMHelpBook *)book withHelpWindowController:(nonnull NHMHelpWindowController *)windowController;

@end

@protocol NHMHelpManagerSearchProtocol <NSObject>

- (BOOL)showSearchString:(nonnull NSString *)anchor inBook:(nonnull NHMHelpBook *)book withHelpWindowController:(nonnull NHMHelpWindowController *)windowController;

@end
