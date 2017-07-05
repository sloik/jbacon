//
//  JIAFryBaconValidationResult.h
//  jBacon
//
//  Created by Developer iOS on 17.12.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class representing validation result on frying bacon screen.
 */
@interface JIAFryBaconValidationResult : NSObject

@property (nonatomic, assign) BOOL hasValidUUID;
@property (nonatomic, assign) BOOL hasValidMajor;
@property (nonatomic, assign) BOOL hasValidMinor;
@property (nonatomic, assign) BOOL hasValidName;

/**
 *  Checks if all fields are valid or not.
 *
 *  @return YES if all field are valid, NO otherwise.
 */
- (BOOL)isValid;

@end
