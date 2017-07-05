//
//  UIColor+JIABaconColors.h
//  jBacon
//
//  Created by Developer iOS on 30.10.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JIABaconColors)

#pragma mark - General Colors

/**
 *  Application default colour.
 *
 *  @return Instance of UIColor.
 */
+ (UIColor *)defaultApplicationColor;

#pragma mark - Font Colors

/**
 *  Default color for labels, text fields etc.
 *
 *  @return Instance of UIColor.
 */
+ (UIColor *)fontColorsDefaultFontColor;

/**
 *  Default color for labels in sections in table views.
 *
 *  @return Instance of UIColor.
 */
+(UIColor *)fontColorsDefaultSectionHeadingColor;

#pragma mark - UI Elements Colors

/**
 *  Default bacground color.
 *
 *  @return Instance of UIColor.
 */
+ (UIColor *)defaultBackgroundColor;

+ (UIColor *)cellsBackgroundColorForEavenCells;

@end
