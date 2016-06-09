//
//  NHMHelpWindowProtocols.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/6/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NHMHelpWindowConstants.h"
#import "NHMHelpWindowContentResponse.h"

typedef NS_ENUM(NSUInteger, NHMHelpWindowContentType) {
    NHMHelpWindowContentURL,
    NHMHelpWindowContentFilePath,
    NHMHelpWindowContentHTMLString,
    NHMHelpWindowContentAttributedString,
    NHMHelpWindowContentOther
};

@protocol NHMHelpWindowContentProtocol <NSObject>
@required
- (NHMHelpWindowContentType)contentTypeForAnchor:(nonnull NSString *)anchor;
@optional
- (nonnull NHMHelpWindowURLContentResponse *)urlForAnchor:(nonnull NSString *)anchor;
- (nonnull NHMHelpWindowFilePathContentResponse *)pathForAnchor:(nonnull NSString *)anchor;
- (nonnull NHMHelpWindowHTMLStringContentResponse *)htmlStringForAnchor:(nonnull NSString *)anchor;

- (nonnull NHMHelpWindowAttributedStringContentResponse *)attributedStringForAnchor:(nonnull NSString *)anchor;

- (void)didBeginLoadingContentForAnchor:(nonnull NSString *)anchor inView:(nonnull __kindof NSView *)view;


@end

@protocol NHMHelpWindowTaskbarProtocol <NSObject>
- (BOOL)contentsButtonEnabledForAnchor:(nonnull NSString *)anchor;
- (nullable NSDictionary <NSString *, NSString *> *)contentsForAnchor:(nonnull NSString *)anchor;

- (BOOL)backButtonEnabledForAnchor:(nonnull NSString *)anchor;
- (nonnull SEL)backButtonActionForAnchor:(nonnull NSString *)anchor;

- (BOOL)frontButtonEnabledForAnchor:(nonnull NSString *)anchor;
- (nonnull SEL)frontButtonActionForAnchor:(nonnull NSString *)anchor;

- (BOOL)sharingButtonEnabledForAnchor:(nonnull NSString *)anchor;
- (nonnull NSSharingServicePicker *)sharingPickerForAnchor:(nonnull NSString *)anchor;

- (BOOL)searchFieldEnabledForAnchor:(nonnull NSString *)anchor;
@end


@protocol NHMHelpWindowSearchProtocol <NSObject>

- (nullable NSArray <NSString *> *)suggestionsForSearchTerm:(nonnull NSString *)string;

@end

