//
//  JIABaconInformation.h
//  jBacon
//
//  Created by Developer iOS on 01.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@interface JIABaconInformation : NSObject <NSCoding>

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *major;
@property (nonatomic, strong) NSNumber *minor;

@property (assign, nonatomic) CLProximity proximity;
@property (assign, nonatomic) CLLocationAccuracy accuracy;
@property (assign, nonatomic) NSInteger rssi;

+ (instancetype) baconInformationWithBacon:(CLBeacon *)bacon
                                      name:(NSString *)name;

- (instancetype)initWithUUID:(NSString *)uuid
                        name:(NSString *)name
                       major:(NSNumber *)major
                       minor:(NSNumber *)minor NS_DESIGNATED_INITIALIZER;

- (NSString *)dataDescription;

- (id)initWithCoder:(NSCoder *)coder;

- (void)encodeWithCoder:(NSCoder *)coder;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToInformation:(JIABaconInformation *)information;

- (NSUInteger)hash;
@end
