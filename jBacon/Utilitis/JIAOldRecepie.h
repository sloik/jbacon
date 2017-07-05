//
//  JIAOldRecepie.h
//  jBacon
//
//  Created by Developer iOS on 05.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JIABaconInformation.h"

@interface JIAOldRecepie : NSObject <NSCoding>

@property (nonatomic, strong) NSDate *addingTime;
@property (nonatomic, copy) JIABaconInformation *baconInformation;

- (instancetype)initWithBaconInformation:(JIABaconInformation *)baconInformation
                              addingTime:(NSDate *)addingTime NS_DESIGNATED_INITIALIZER;


- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToRecepie:(JIAOldRecepie *)recepie;

- (NSUInteger)hash;
@end
