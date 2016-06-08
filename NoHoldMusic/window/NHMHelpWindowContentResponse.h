//
//  NHMHelpWindowContentResponse.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/7/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHMHelpWindowURLContentResponse : NSObject
@property (nonnull) NSURL *url;
+ (nonnull instancetype)contentResponseWithURL:(nonnull NSURL *)url;
@end

@interface NHMHelpWindowFilePathContentResponse : NSObject
@property (nonnull) NSString *path;
@property (nullable) NSString *enclosingPath;
+ (nonnull instancetype)contentResponseWithPath:(nonnull NSString *)path enclosingPath:(nullable NSString *)enclosingPath;
@end

@interface NHMHelpWindowHTMLStringContentResponse : NSObject
@property (nonnull) NSString *htmlString;
@property (nullable) NSURL *baseURL;
+ (nonnull instancetype)contentResponseWithHTMLString:(nonnull NSString *)htmlString baseURL:(nullable NSURL *)baseURL;
@end

@interface NHMHelpWindowAttributedStringContentResponse : NSObject
@property (nonnull) NSAttributedString *attributedString;
+ (nonnull instancetype)contentResponseWithAttributedString:(nonnull NSAttributedString *)attributedString;
@end
