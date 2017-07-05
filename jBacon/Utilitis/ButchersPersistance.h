//
//  Created by Developer iOS on 01.12.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JIAButcher.h"

@protocol ButchersPersistanceEventDelegate <NSObject>

- (void)didSavedButcher;
- (void)didRemoveButcher;
- (void)didRestoreDefaultButchers;

@end

@interface ButchersPersistance : NSObject

+(ButchersPersistance *)sharedButchers;

@property (nonatomic, weak) id <ButchersPersistanceEventDelegate> eventDelegate;

- (void)saveButcher:(JIAButcher *)butcher;
- (void)removeButcher:(JIAButcher *)butcher;

- (NSArray *)knownButchers;

- (void)synchronize;

- (NSSet *)estimoteBacons;

- (void)restoreDefaultButchers;

- (void)firsTimeRestore;

- (NSString *)butcherNameForUUID:(NSString *)uuid;

@end
