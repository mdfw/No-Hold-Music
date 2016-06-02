//
//  NHMHelpSystem.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/11/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHMHelpManager : NSObject

+ (nonnull id)sharedHelpManager;


- (void)openHelpAnchor:(nonnull NSString *)anchor inBook:(nullable NSString *)book;
- (void)findString:(nonnull NSString *)query inBook:(nullable NSString *)book;

/* Register one or more help books in the given bundle.  The main bundle is automatically registered by -openHelpAnchor:inBook: and -findString:inBook:.  You can use -registerBooksInBundle: to register help books in a plugin bundle, for example.  The Info.plist in the bundle should contain a help book directory path, which specifies one or more folders containing help books.  Returns NO if the bundle doesn't contain any help books or if registration fails.  Returns YES on successful registration. */
- (BOOL)registerBooksInBundle:(nonnull NSBundle *)bundle;


/**
 *  Show the help window.
 *
 *  @param sender The object requesting the window.
 */
- (IBAction)showHelp:(nullable id)sender;
@end
