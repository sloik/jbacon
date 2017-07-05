//
//  JIABaconInformation.m
//  jBacon
//
//  Created by Developer iOS on 01.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "JIABaconInformation.h"

@implementation JIABaconInformation

+ (instancetype) baconInformationWithBacon:(CLBeacon *)bacon
                                      name:(NSString *)name
{
    if (bacon == nil) {
        return  nil;
    }
    
    NSString *uuidString = [bacon.proximityUUID UUIDString];
    
    return [[self alloc] initWithUUID:uuidString
                                 name:name
                                major:bacon.major
                                minor:bacon.minor];
    
}

- (instancetype)initWithUUID:(NSString *)uuid
                        name:(NSString *)name
                       major:(NSNumber *)major
                       minor:(NSNumber *)minor
{
    self = [super init];
    if (self != nil) {
        _uuid = [uuid copy];
        _name = [name copy];
        _major = major;
        _minor = minor;
    }
    return self;
}

- (NSString *)dataDescription
{
    return [NSString stringWithFormat:@"UUID: %@\tName: %@\tMajor: %@\tMinor: %@",
            self.uuid,
            self.name,
            [self.major stringValue],
            [self.minor stringValue]];
}

- (NSString *)description
{
    NSString *description = [super description];
    
    return [NSString stringWithFormat:@"%@\nUUID: %@\nName: %@\nMajor: %@\nMinor: %@",
            description, self.uuid, self.name, [self.major stringValue], [self.minor stringValue]];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;
    
    return [self isEqualToInformation:other];
}

- (BOOL)isEqualToInformation:(JIABaconInformation *)information {
    if (self == information)
        return YES;
    if (information == nil)
        return NO;
    if (self.uuid != information.uuid && ![self.uuid isEqualToString:information.uuid])
        return NO;
    if (self.name != information.name && ![self.name isEqualToString:information.name])
        return NO;
    if (self.major != information.major && ![self.major isEqualToNumber:information.major])
        return NO;
    if (self.minor != information.minor && ![self.minor isEqualToNumber:information.minor])
        return NO;
    if (self.proximity != information.proximity)
        return NO;
    if (self.accuracy != information.accuracy)
        return NO;
    if (self.rssi != information.rssi)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.uuid hash];
    hash = hash * 31u + [self.name hash];
    hash = hash * 31u + [self.major hash];
    hash = hash * 31u + [self.minor hash];
    hash = hash * 31u + (NSUInteger) self.proximity;
    hash = hash * 31u + [[NSNumber numberWithDouble:self.accuracy] hash];
    hash = hash * 31u + self.rssi;
    return hash;
}

#pragma mark - NSCoding

// TODO: move those to consts
- (id)initWithCoder:(NSCoder *)deCoder {
    self = [self initWithUUID:[deCoder decodeObjectForKey:@"self.uuid"]
                         name:[deCoder decodeObjectForKey:@"self.name"]
                        major:[deCoder decodeObjectForKey:@"self.major"]
                        minor:[deCoder decodeObjectForKey:@"self.minor"]];
    if (self) {
        self.proximity = (CLProximity) [deCoder decodeIntForKey:@"self.proximity"];
        self.accuracy = [deCoder decodeDoubleForKey:@"self.accuracy"];
        self.rssi = [deCoder decodeIntForKey:@"self.rssi"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.uuid forKey:@"self.uuid"];
    [coder encodeObject:self.name forKey:@"self.name"];
    [coder encodeObject:self.major forKey:@"self.major"];
    [coder encodeObject:self.minor forKey:@"self.minor"];
    [coder encodeInt:self.proximity forKey:@"self.proximity"];
    [coder encodeDouble:self.accuracy forKey:@"self.accuracy"];
    [coder encodeInt:(int)self.rssi forKey:@"self.rssi"];
}

@end
