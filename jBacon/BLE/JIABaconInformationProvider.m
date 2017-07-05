//
//  JIABaconInformationProvider.m
//  jBacon
//
//  Created by Developer iOS on 30.10.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import CoreLocation;

#import "JIABaconInformationProvider.h"
#import "ButchersPersistance.h"

@interface JIABaconInformationProvider () <JIADeviceScanerDelegate>

@property (atomic, strong) NSMutableArray *bacons;

@property (nonatomic, strong) JIABluetoothDeviceScanner *deviceScaner;

@property (nonatomic, readwrite, weak) UITableView *tableView;

@end

@implementation JIABaconInformationProvider

- (instancetype)initWithTableView:(UITableView *)tableView
                    deviceScanner:(JIABluetoothDeviceScanner *)deviceScanner
{
    self = [super init];
    if (self != nil) {
        _bacons = [NSMutableArray new];
        
        _tableView = tableView;
        
        _deviceScaner = deviceScanner;
        _deviceScaner.scanerDelegate = self;
        
        [_deviceScaner startMonitoringAllRegions];
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    return [self initWithTableView:tableView
                     deviceScanner:[JIABluetoothDeviceScanner new]];
}

- (NSArray *)allBeacons
{
    return [NSArray arrayWithArray:self.bacons];
}

- (void)startLookingForBacon
{
    [self.deviceScaner startMonitoringAllRegions];
}

#pragma mark - JIABluetoothDeviceScanner

- (void)deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
   didDetermineState:(CLRegionState)state
           forRegion:(CLBeaconRegion *)rgion
{
    if (state == CLRegionStateOutside || state == CLRegionStateUnknown) {
        [self removeBaconInformationForRegion:rgion];
    }
}

- (void)deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
       didExitRegion:(CLBeaconRegion *)region
{
    [self removeBaconInformationForRegion:region];
}

- (void)deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
     didRangeBeacons:(NSArray *)beacons
            inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *bacon in beacons) {
        [self updateBacon:bacon];
    }
    
    [self.contentListener informationProviderHasNewData:self];
}

- (void)deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
    didFailForRegion:(CLBeaconRegion *)region
           withError:(NSError *)error
{
    [self.errorListener informationProvider:self
                           didFailForRegion:region
                                  withError:error];
}

- (void)        deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
  didStopMonitoringForRegion:(CLBeaconRegion *)region
{
    [self removeBaconInformationForRegion:region];
    
    // TODO: Wywalenie z tego miejsca nie odswieza listingu tabelki...
}

#pragma mark - Helper methods

- (void)removeBaconInformationForRegion:(CLBeaconRegion *)region
{
    NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
    NSUInteger removedRow = NSNotFound;
    NSMutableArray *removedRows = [NSMutableArray new];
    
    for (NSUInteger row = 0; row < self.bacons.count; row++) {
        JIABaconInformation *bacon = self.bacons[row];
        if ([bacon.uuid isEqualToString:[region.proximityUUID UUIDString]]) {
            removedRow = row;
            [discardedItems addIndex:row];
            [removedRows addObject:@(removedRow)];
        }
    }
    
    if ([discardedItems count] > 0) {
        
        [self.bacons removeObjectsAtIndexes:discardedItems];
        
        [self deleteRowsAtRemovedRows:[NSArray arrayWithArray:removedRows]];
    }
}

- (void)deleteRowsAtRemovedRows:(NSArray *)removedRows
{
    for (NSNumber *rowIndex in removedRows) {
        
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[rowIndex integerValue]
                                                                    inSection:0]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endUpdates];
    }
}

- (JIABaconInformation *)addNewBaconInformationFromBacon:(CLBeacon *)bacon
                                usingButchersPersistance:(ButchersPersistance *)butchersPersistance
{
    if (bacon == nil) {
        return nil;
    }
    
    NSString *uuidString = [bacon.proximityUUID UUIDString];
    NSString *nameString = [butchersPersistance butcherNameForUUID:uuidString];
    
    JIABaconInformation *baconInformationToAdd = [[JIABaconInformation alloc] initWithUUID:uuidString
                                                                                      name:nameString
                                                                                     major:bacon.major
                                                                                     minor:bacon.minor];
    [self.bacons addObject:baconInformationToAdd];
    
    return baconInformationToAdd;
}

- (void)updateBacon:(CLBeacon *)bacon
{
    JIABaconInformation *baconInformation = [self existingBaconInformationForBacon:bacon];
    
    if (baconInformation != nil) {
        
        baconInformation.proximity = bacon.proximity;
        baconInformation.rssi = bacon.rssi;
        baconInformation.accuracy = bacon.accuracy;
        
        [self.contentListener informationProviderHasNewData:self];
    }
    else {
        [self updateExistingModelAndUIForBacon:bacon];
    }
}

- (void)updateExistingModelAndUIForBacon:(CLBeacon *)bacon
{
    JIABaconInformation *addedBacon = [self addNewBaconInformationFromBacon:bacon
                                                   usingButchersPersistance:[ButchersPersistance sharedButchers]];
    if (addedBacon) {
        [self sortBacons];
        [self insertRowToTableViewForBaconInformation:addedBacon];
    }
}

- (void)insertRowToTableViewForBaconInformation:(JIABaconInformation *)baconInformation
{
    NSIndexPath *indexPath = [self indexPathForBaconInformation:baconInformation];
    if (indexPath != nil) {
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endUpdates];
    }
}

/**
 *  Helper method to serch for a bacon infrmation object in all bacons.
 *
 *  @param bacon CLBeacon object used as a predicate.
 *
 *  @return Returnes found object or nil if no matches were found.
 */
- (JIABaconInformation *)existingBaconInformationForBacon:(CLBeacon *)bacon
{
    JIABaconInformation *baconInformation = [self baconInformationForBacon:bacon];
    
    return baconInformation;
}

/**
 *  Helper method to search for bacon information object in all becons.
 *
 *  @param bacon CLBeacon that should be used as a predicate.
 *
 *  @return Returnes found object or nil if no matches were found.
 */
- (JIABaconInformation *)baconInformationForBacon:(CLBeacon *)bacon
{
    __block JIABaconInformation *baconInformationToReturn = nil;
    
    JIABaconInformation *lookingFor = [JIABaconInformation baconInformationWithBacon:bacon
                                                                                name:@""];
    
    NSAssert(lookingFor != nil, @"This object should be created");
    
    [self.bacons enumerateObjectsWithOptions:NSEnumerationConcurrent
                                  usingBlock:^(JIABaconInformation *baconInformation, NSUInteger idx, BOOL *stop)
     {
         BOOL hasTheSameProximityUUID = [[bacon.proximityUUID UUIDString] isEqualToString:lookingFor.uuid];
         BOOL hasTheSameMajor = [bacon.major isEqualToNumber:lookingFor.major];
         BOOL hasTheSameMinor = [bacon.minor isEqualToNumber:lookingFor.minor];
         
         if (hasTheSameMajor && hasTheSameMinor && hasTheSameProximityUUID) {
             *stop = YES;
             baconInformationToReturn = baconInformation;
         }
     }];
    
    return baconInformationToReturn;
}

- (void)sortBacons
{
    NSArray *sortedBacons = [self.bacons sortedArrayUsingComparator:^NSComparisonResult(JIABaconInformation *baconLeft,
                                                                                        JIABaconInformation *baconRight)
                             {
                                 NSComparisonResult result = [baconLeft.dataDescription compare:baconRight.dataDescription
                                                                             options:0];
                                 
                                 return result;
                             }];
    
    self.bacons = [NSMutableArray arrayWithArray:sortedBacons];
}

- (NSIndexPath *)indexPathForBaconInformation:(JIABaconInformation *)bacon
{
    NSUInteger row = [self.bacons indexOfObject:bacon];
    
    if (row != NSNotFound)
    {
        return [NSIndexPath indexPathForRow:row
                                  inSection:0];
    }
    
    return nil;
}

@end
