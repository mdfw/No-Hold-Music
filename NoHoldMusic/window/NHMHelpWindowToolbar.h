//
//  NHMHelpWindowToolbar.h
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 5/11/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, NHMHelpWindowFloatState) {
    NHMHelpWindowFloatStateOff = 0,
    NHMHelpWindowFloatStateOn = 1
};

@interface NHMHelpWindowToolbar : NSToolbar
/**
 *  The button that implements the share options.
 */
@property (weak, nullable) IBOutlet NSButton *shareToolbarButton;

/**
 *  The button that triggers float and unfloat of the window.
 *  @warning Do not directly set the image here. Use the setFloatToolbarButtonImage... option.
 */
@property (weak, nullable) IBOutlet NSButton *floatToolbarButton;

/**
 *  The segmented control that indicates the back and forth navigation controls.
 */
@property (weak, nullable) IBOutlet NSSegmentedControl *navigationToolbarSegmentedControl;

/**
 *  The search field.
 */
@property (weak, nullable) IBOutlet NSSearchField *toolbarSearchField;

/**
 *  Returns a new copy of the HelpWindowToolbar.
 *  @note This is preferable to alloc/init as this pulls the right set of 
 *        toolbarItems from the nib.
 *
 *  @return HelpWindowToolbar
 */
+ (nullable instancetype)helpWindowToolbar;

/**
 *  Show the float toolbar button?
 *
 *  @param show Pass yes to show the float toolbar button. Will only show one.
 */
- (void)showFloatToolbarItem:(BOOL)show;

/**
 *  Show the share toolbar button?
 *
 *  @param show Pass yes to show the share toolbar button.
 */
- (void)showShareToolbarItem:(BOOL)show;

/**
 *  Set the float toolbar image.
 *
 *  @param image The image for the toolbar.
 *  @param state The state to set the button image for.
 */
- (void)setFloatToolbarButtonImage:(NSImage * __nonnull)image forState:(NHMHelpWindowFloatState)state;

/**
 *  The current float toolbar button image. If it is custom set, will return that image, otherwise will return builtin image.
 *
 *  @param state The state requested.
 *
 *  @return Either the custom values or the built in.
 *  @warning Passing invalid state will result in the off state image returned.
 */
- (NSImage * __nonnull)floatToolbarButtonImageForState:(NHMHelpWindowFloatState)state;

/**
 *  Sets the state of the float window button. Uses the images above or the builtin balloon.
 *
 *  @param state The state for the button.
 *  @note If the button is not visible, does not affect anything.
 */
- (void)switchFloatToolbarButtonImageToState:(NHMHelpWindowFloatState)state;
@end
