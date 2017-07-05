//
//  JIAOldRecepiesInformationManager.h
//  jBacon
//
//  Created by Developer iOS on 05.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import Foundation;

#import "JIAOldRecepie.h"

/**
 *  Class used to manage old recepies.
 */
@interface JIAOldRecepiesInformationManager : NSObject

- (JIABaconInformation *)newestBacon;

/**
 *  Used to obtain single instance of the recepies information manager.
 *
 *  @return Instance of JIAOldRecepiesInformationManager.
 */
+ (instancetype)sharedManager;

/**
 *  Stored old recepies sorted by the store date.
 *
 *  @return Array of JIAOldRecepie objects.
 */
- (NSArray *)oldRecepies;

/**
 *  Saves bacon recepie.
 *
 *  @param bacon Information about the bacon that will be stored.
 */
- (void)storeRecepieForBacon:(JIABaconInformation *)bacon;

/**
 *  Method used for getting number of saved recepies.
 *
 *  @return Number of saved recepies.
 */
- (NSUInteger)recepiesCount;

/**
 *  Forces a sort and save.
 */
- (void)synchronize;

@end
