//
//  NHMHelpWindowContentResponse.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/7/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import "NHMHelpWindowContentResponse.h"

@implementation NHMHelpWindowURLContentResponse
+ (nonnull instancetype)contentResponseWithURL:(nonnull NSURL *)url {
    NHMHelpWindowURLContentResponse *response = [[NHMHelpWindowURLContentResponse alloc] init];
    if (response) {
        response.url = url;
    }
    return response;
}
@end

@implementation NHMHelpWindowFilePathContentResponse
+ (nonnull instancetype)contentResponseWithPath:(nonnull NSString *)path enclosingPath:(nullable NSString *)enclosingPath {
    NHMHelpWindowFilePathContentResponse *response = [[NHMHelpWindowFilePathContentResponse alloc] init];
    if (response) {
        response.path = path;
        response.enclosingPath = path;
    }
    return response;
}
@end

@implementation NHMHelpWindowHTMLStringContentResponse
+ (nonnull instancetype)contentResponseWithHTMLString:(nonnull NSString *)htmlString baseURL:(nullable NSURL *)baseURL {
    NHMHelpWindowHTMLStringContentResponse *response = [[NHMHelpWindowHTMLStringContentResponse alloc] init];
    if (response) {
        response.htmlString = htmlString;
        response.baseURL = baseURL;
    }
    return response;
}
@end

@implementation NHMHelpWindowAttributedStringContentResponse
+ (nonnull instancetype)contentResponseWithAttributedString:(nonnull NSAttributedString *)attributedString {
    NHMHelpWindowAttributedStringContentResponse *response = [[NHMHelpWindowAttributedStringContentResponse alloc] init];
    if (response) {
        response.attributedString = attributedString;
    }
    return response;
}
@end
