//
//  NHMHelpWindowProtocols.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/6/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, NHMHelpWindowContentType) {
    NHMHelpWindowContentURL,
    NHMHelpWindowContentHTMLString,
    NHMHelpWindowContentAttributedString,
    NHMHelpWindowContentOther
};

@protocol NHMHelpWindowContentProtocol <NSObject>
@required
- (NHMHelpWindowContentType)contentTypeForAnchor:(NSString *)anchor;
@optional
- (NSURL *)urlForAnchor:(NSString *)anchor;
- (NSString *)htmlStringForAnchor:(NSString *)anchor;
- (NSAttributedString *)attributedStringForAnchor:(NSString *)anchor;
- (id)beganLoadingContentForAnchor:(NSString *)anchor;


@end

@protocol NHMHelpWindowTaskbarProtocol <NSObject>
- (BOOL)contentsButtonEnabledForAnchor:(NSString *)anchor;
- (NSDictionary {<NSString *>, <NSString *>} *)contentsForAnchor:(NSString *)anchor;

- (BOOL)backButtonEnabledForAnchor:(NSString *)anchor;
- (@selector)backButtonActionForAnchor:(NSString *)anchor;

- (BOOL)frontButtonEnabledForAnchor:(NSString *)anchor;
- (@selector)frontButtonActionForAnchor:(NSString *)anchor;

- (BOOL)sharingButtonEnabledForAnchor:(NSString *)anchor;
- (NSSharingServicePicker *)sharingPickerForAnchor:(NSString *)anchor;

- (BOOL)searchFieldEnabledForAnchor:(NSString *)anchor;
@end


@protocol NHMHelpWindowSearchProtocol <NSObject>

- (NSArray <NSString *> *)suggestionsForSearchTerm:(NSString *)string;

@end