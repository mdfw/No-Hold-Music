//
//  NHMHelpSystem.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/11/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHMHelpManager : NSObject

+ (nonnull id)sharedHelpSystem;

/**
 *  Show the help window.
 *
 *  @param sender The object requesting the window.
 */
- (IBAction)showHelpWindow:(nullable id)sender;
@end
