//
//  JIAFryBaconValidationResult.m
//  jBacon
//
//  Created by Developer iOS on 17.12.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "JIAFryBaconValidationResult.h"

@implementation JIAFryBaconValidationResult

- (BOOL)isValid
{
    return (self.hasValidUUID && self.hasValidMajor && self.hasValidMinor && self.hasValidName);
}

@end
