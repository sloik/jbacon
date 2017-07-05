//
//  JIABluetoothDeviceScanner.m
//  jBacon
//
//  Created by Developer iOS on 30.10.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import UIKit;

#import "JIABluetoothDeviceScanner.h"
#import "ButchersPersistance.h"

@interface JIABluetoothDeviceScanner () <CLLocationManagerDelegate, ButchersPersistanceEventDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) ButchersPersistance *butcherPersistance;

@end

@implementation JIABluetoothDeviceScanner

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
		
		_butcherPersistance = [ButchersPersistance sharedButchers];
		_butcherPersistance.eventDelegate = self;
    }
    
    return self;
}

#pragma mark - Public API

- (void)startMonitoringAllRegions
{
    [self stopMonitoringAllRegions];
    
    NSArray *knownButchers = [self.butcherPersistance knownButchers];
    
    for (JIAButcher *butcher in knownButchers) {
        [self startMonitoringForButcher:butcher];
    }
    
}

- (void)startMonitoringForButcher:(JIAButcher *)butcher
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:butcher.uuid];
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                identifier:butcher.name];
    
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;
    
    [_locationManager startMonitoringForRegion:region];
    [_locationManager startRangingBeaconsInRegion:region];
}

- (void)stopMonitoringAllRegions
{
    for (CLRegion *region  in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
        
        if ([region isKindOfClass:[CLBeaconRegion class]]) {
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
            
            if ([self.scanerDelegate respondsToSelector:@selector(deviceScaner:didStopMonitoringForRegion:)]) {
                
                [self.scanerDelegate deviceScaner:self
                       didStopMonitoringForRegion:(CLBeaconRegion *)region];
            }
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        CLBeaconRegion *baconRegion = (CLBeaconRegion *)region;
        
        if ([self.scanerDelegate respondsToSelector:@selector(deviceScaner:didDetermineState:forRegion:)]) {
            
            [self.scanerDelegate deviceScaner:self
                            didDetermineState:state
                                    forRegion:baconRegion];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        CLBeaconRegion *baconRegion = (CLBeaconRegion *)region;
        if ([self.scanerDelegate respondsToSelector:@selector(deviceScaner:didEnterRegion:)]) {
            
            [self.scanerDelegate deviceScaner:self
                               didEnterRegion:baconRegion];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        CLBeaconRegion *baconRegion = (CLBeaconRegion *)region;
        
        if ([self.scanerDelegate respondsToSelector:@selector(deviceScaner:didExitRegion:)]) {
            
            [self.scanerDelegate deviceScaner:self
                                didExitRegion:baconRegion];
        }
    }
}

- (void)    locationManager:(CLLocationManager *)manager
 monitoringDidFailForRegion:(CLRegion *)region
                  withError:(NSError *)error
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        
        CLBeaconRegion *baconRegion = (CLBeaconRegion *)region;
        
        if ([self.scanerDelegate respondsToSelector:@selector(deviceScaner:didFailForRegion:withError:)]) {
            
            [self.scanerDelegate deviceScaner:self
                             didFailForRegion:baconRegion
                                    withError:error];
        }
    }
}

- (void)        locationManager:(CLLocationManager *)manager
   didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self startMonitoringAllRegions];
        
        [self.locationManager startUpdatingLocation];
    }
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    if ([self.scanerDelegate respondsToSelector:@selector(deviceScaner:didRangeBeacons:inRegion:)]) {
        
        [self.scanerDelegate deviceScaner:self
                          didRangeBeacons:beacons
                                 inRegion:region];
    }
}

- (void)        locationManager:(CLLocationManager *)manager
 rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
                      withError:(NSError *)error
{
    if ([self.scanerDelegate respondsToSelector:@selector(deviceScaner:didFailForRegion:withError:)]) {
        
        [self.scanerDelegate deviceScaner:self
                         didFailForRegion:region
                                withError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if ([self.scanerDelegate respondsToSelector:@selector(deviceScaner:didFailWithLocationManager:withError:)]) {
        
        [self.scanerDelegate deviceScaner:self
               didFailWithLocationManager:manager
                                withError:error];
    }
}

#pragma mark - ButchersPersistanceEventDelegate

- (void)didSavedButcher
{
    [self startMonitoringAllRegions];
}

- (void)didRemoveButcher
{
    [self startMonitoringAllRegions];
}

- (void)didRestoreDefaultButchers
{
    [self startMonitoringAllRegions];
}

@end
