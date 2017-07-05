//
//  JIABluetoothDeviceScanner.h
//  jBacon
//
//  Created by Developer iOS on 30.10.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@class JIABluetoothDeviceScanner;

@protocol JIADeviceScanerDelegate <NSObject>
@optional
- (void)        deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
  didStopMonitoringForRegion:(CLBeaconRegion *)region;

- (void)deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
   didDetermineState:(CLRegionState)state
           forRegion:(CLBeaconRegion *)rgion;

- (void)deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
      didEnterRegion:(CLBeaconRegion *)region;

- (void)deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
       didExitRegion:(CLBeaconRegion *)region;

- (void)deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
     didRangeBeacons:(NSArray *)beacons
            inRegion:(CLBeaconRegion *)region;

- (void)deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
    didFailForRegion:(CLBeaconRegion *)region
           withError:(NSError *)error;

- (void)        deviceScaner:(JIABluetoothDeviceScanner *)deviceScaner
  didFailWithLocationManager:(CLLocationManager *)locationManager
                   withError:(NSError *)error;

@end

/**
 *  Class used for scanning of BT devices.
 */
@interface JIABluetoothDeviceScanner : NSObject

@property (nonatomic, readonly) CLLocationManager *locationManager;

@property (nonatomic, weak) id <JIADeviceScanerDelegate> scanerDelegate;

- (void)stopMonitoringAllRegions;

- (void)startMonitoringAllRegions;

@end
