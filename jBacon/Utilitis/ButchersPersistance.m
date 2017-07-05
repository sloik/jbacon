//
//  Created by Developer iOS on 01.12.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "ButchersPersistance.h"

static NSString *const kButchersPersistanceKeyForButchers = @"kButchersPersistanceKeyForButchers";
static NSString *const kButchersPersistanceKeyForFirstTimeRun = @"kButchersPersistanceKeyForFirstTimeRun";

@interface ButchersPersistance ()

@property (nonatomic, strong) NSMutableArray *butchers;

@end

@implementation ButchersPersistance

+(ButchersPersistance *)sharedButchers
{
    static ButchersPersistance *_persistance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _persistance = [ButchersPersistance new];
    });
    
    return _persistance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _butchers = [self loadFromFile];
    }
    return self;
}

- (NSSet *)estimoteBacons
{
    // read data from the plist file
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"initialBaconsIDs"
                                                          ofType:@"plist"];
    
    NSDictionary *baconUUIDs = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSAssert(baconUUIDs != nil, nil);
    
    NSMutableSet *butchers = [NSMutableSet new];
    
    for (NSString *keyButcherName in baconUUIDs) {
        JIAButcher *butcher = [JIAButcher new];
        
        butcher.name = keyButcherName;
        butcher.uuid = baconUUIDs[keyButcherName];
        
        [butchers addObject:butcher];
    }
    
    return [NSSet setWithSet:butchers];
}

- (void)saveButcher:(JIAButcher *)butcher
{
    BOOL constinsButcher = [self.butchers containsObject:butcher];
    
    if (constinsButcher == NO) {
        [self.butchers addObject:butcher];
        [self synchronize];
        
        [self.eventDelegate didSavedButcher];
    }
}

- (void)removeButcher:(JIAButcher *)butcher
{
    [self.butchers enumerateObjectsUsingBlock:^(JIAButcher *storedButcher, NSUInteger idx, BOOL *stop) {
        if ([storedButcher isEqualToButcher:butcher]) {
            *stop = YES;
            [self.butchers removeObjectAtIndex:idx];
            [self synchronize];
            
            [self.eventDelegate didRemoveButcher];
        }
    }];
}

- (void)synchronize
{
    [self saveToFile];
}

- (NSMutableArray *)loadFromFile
{
    NSData *archivedButchers = [[NSUserDefaults standardUserDefaults] dataForKey:kButchersPersistanceKeyForButchers];
    NSArray *butchers = archivedButchers ? [NSKeyedUnarchiver unarchiveObjectWithData:archivedButchers] : nil;
    
    return butchers ? [NSMutableArray arrayWithArray:butchers] : [NSMutableArray new];
}

- (void)saveToFile
{
    NSData *archivedButchers = [NSKeyedArchiver archivedDataWithRootObject:self.butchers];
    
    [[NSUserDefaults standardUserDefaults] setObject:archivedButchers
                                              forKey:kButchersPersistanceKeyForButchers];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)knownButchers
{
    return [NSArray arrayWithArray:self.butchers];
}

- (void)restoreDefaultButchers
{
    NSSet *defaultButchers = [self estimoteBacons];
    
    self.butchers = [NSMutableArray new];
    
    for (JIAButcher *butcher in defaultButchers) {
        [self saveButcher:butcher];
    }
    
    [self.eventDelegate didRestoreDefaultButchers];
}

- (void)firsTimeRestore
{
    BOOL wasRestored = [[NSUserDefaults standardUserDefaults] boolForKey:kButchersPersistanceKeyForFirstTimeRun];
    
    if (wasRestored == NO) {
        [self restoreDefaultButchers];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:kButchersPersistanceKeyForFirstTimeRun];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 *  Method used to find for a bucher name with a given UUID.
 *
 *  @param uuid UUID for which to find the name.
 *
 *  @return Name for the butcher with given UUID or UUID if not found.
 */
- (NSString *)butcherNameForUUID:(NSString *)uuid
{
    for (JIAButcher *burcher in [self knownButchers]) {
        if ([burcher.uuid isEqualToString:uuid]) {
            return burcher.name;
        }
    }
    
    return [uuid copy];
}

@end
