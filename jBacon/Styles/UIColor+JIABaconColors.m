//
//  UIColor+JIABaconColors.m
//  jBacon
//
//  Created by Developer iOS on 30.10.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "UIColor+JIABaconColors.h"

@implementation UIColor (JIABaconColors)

#pragma mark - General Colors

+ (UIColor *)defaultApplicationColor
{
    return [self colorWithRed:190.0f / 255.0f
                        green:69.0f  / 255.0f
                         blue:42.0f  / 255.0f
                        alpha:1.0];
}

#pragma mark - Font Colors

+ (UIColor *)fontColorsDefaultFontColor
{
    return [self defaultApplicationColor];
}

+ (UIColor *)fontColorsDefaultSectionHeadingColor
{
    return [self blackColor];
}

#pragma mark - UI Elements Colors

+ (UIColor *)defaultBackgroundColor
{
    return [self whiteColor];
}

+ (UIColor *)cellsBackgroundColorForEavenCells
{
    return [UIColor colorWithWhite:0.97
                             alpha:1.0];
}

@end
