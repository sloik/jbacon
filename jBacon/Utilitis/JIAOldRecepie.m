//
//  Created by Developer iOS on 05.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "JIAOldRecepie.h"

static NSString *const kKeyForBaconInformation = @"kKeyForBaconInformation";
static NSString *const kKeyForAddingTime       = @"kKeyForAddingTime";

@implementation JIAOldRecepie

- (instancetype)initWithBaconInformation:(JIABaconInformation *)baconInformation
                              addingTime:(NSDate *)addingTime
{
    self = [super init];
    if (self) {
        _baconInformation = baconInformation;
        _addingTime = addingTime;
    }
    return self;
}

- (NSString *)description
{
    NSString *oryginalDescription = [super description];
    return [NSString stringWithFormat:@"%@\nBacon Information: {\n %@ \n}\nAdding Time: %@\n",
            oryginalDescription, self.baconInformation, self.addingTime];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.baconInformation
                  forKey:kKeyForBaconInformation];
    
    [aCoder encodeObject:self.addingTime
                  forKey:kKeyForAddingTime];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initWithBaconInformation:[aDecoder decodeObjectForKey:kKeyForBaconInformation]
                               addingTime:[aDecoder decodeObjectForKey:kKeyForAddingTime]];
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToRecepie:other];
}

- (BOOL)isEqualToRecepie:(JIAOldRecepie *)recepie {
    if (self == recepie)
        return YES;
    if (recepie == nil)
        return NO;
    if (self.addingTime != recepie.addingTime && ![self.addingTime isEqualToDate:recepie.addingTime])
        return NO;
    if (self.baconInformation != recepie.baconInformation && ![self.baconInformation isEqual:recepie.baconInformation])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.addingTime hash];
    hash = hash * 31u + [self.baconInformation hash];
    return hash;
}

@end
