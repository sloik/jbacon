//
//  JIABluetoothDeviceScannerTests.m
//  jBacon
//
//  Created by Lukasz Stocki on 08.02.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "JIABluetoothDeviceScanner.h"
#import "ButchersPersistance.h"

@interface JIABluetoothDeviceScanner (TESTS) <CLLocationManagerDelegate, ButchersPersistanceEventDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) ButchersPersistance *butcherPersistance;

- (void)startMonitoringForButcher:(JIAButcher *)butcher;

@end

@interface JIABluetoothDeviceScannerTests : XCTestCase

@property (nonatomic, strong) JIABluetoothDeviceScanner *systemUnderTest;
@property (nonatomic, strong) id mockSystem;

@property (nonatomic, strong) id mockLocationManager;
@property (nonatomic, strong) id mockButcherPersistance;
@property (nonatomic, strong) id mockScannerDelegate;

@end

@implementation JIABluetoothDeviceScannerTests

- (void)setUp {
	[super setUp];
	
	self.systemUnderTest = [[JIABluetoothDeviceScanner alloc] init];
	
	self.mockLocationManager = OCMStrictClassMock([CLLocationManager class]);
	self.systemUnderTest.locationManager = self.mockLocationManager;
	
	self.mockButcherPersistance = OCMStrictClassMock([ButchersPersistance class]);
	self.systemUnderTest.butcherPersistance = self.mockButcherPersistance;
	
	self.mockScannerDelegate = OCMStrictProtocolMock(@protocol(JIADeviceScanerDelegate));
	self.systemUnderTest.scanerDelegate = self.mockScannerDelegate;
	
	self.mockSystem = OCMPartialMock(self.systemUnderTest);
}

- (void)tearDown
{
	[self.mockSystem stopMocking];
	[super tearDown];
}

#pragma mark - Public API
- (void)test_startMonitoringAllRegions_stopMonitoringAllAndStartMonitoringForKnownButchers
{
	id mockButcher = OCMStrictClassMock([JIAButcher class]);
	[[[self.mockButcherPersistance stub] andReturn:@[mockButcher]] knownButchers];
	OCMStub([self.mockSystem startMonitoringForButcher:mockButcher]).andDo(nil);
	OCMStub([self.mockSystem stopMonitoringAllRegions]);
	
	[self.systemUnderTest startMonitoringAllRegions];
	
	OCMVerify([self.mockSystem startMonitoringForButcher:mockButcher]);
	OCMVerify([self.mockSystem stopMonitoringAllRegions]);
}

- (void)test_startMonitoringForButcher_ShouldTellLocationManagerToMonitorForButcher
{
	id mockButcher = OCMStrictClassMock([JIAButcher class]);
	NSString *butcherUUID = @"12345678-1234-1234-1234-123456789012";
	NSString *butcherName = @"Butcher Name";
	OCMStub([mockButcher uuid]).andReturn(butcherUUID);
	OCMStub([mockButcher name]).andReturn(butcherName);
	
	OCMExpect([self.mockLocationManager startMonitoringForRegion:OCMOCK_ANY]);
	OCMExpect([self.mockLocationManager startRangingBeaconsInRegion:OCMOCK_ANY]);
	
	[self.mockSystem startMonitoringForButcher:mockButcher];
	
	OCMVerifyAll(self.mockLocationManager);
}

- (void)test_stopMonitoringAllRegions
{
	id mockCLBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
	NSSet *monitoredRegions = [NSSet setWithArray:@[mockCLBeaconRegion]];
	
	OCMStub([self.mockLocationManager monitoredRegions]).andReturn(monitoredRegions);
	
	OCMExpect([self.mockLocationManager stopMonitoringForRegion:mockCLBeaconRegion]);
	OCMExpect([self.mockLocationManager stopRangingBeaconsInRegion:mockCLBeaconRegion]);
	
	OCMExpect([self.mockScannerDelegate deviceScaner:self.systemUnderTest
						  didStopMonitoringForRegion:mockCLBeaconRegion]);
	
	[self.systemUnderTest stopMonitoringAllRegions];
	
	OCMVerifyAll(self.mockLocationManager);
	OCMVerifyAll(self.mockScannerDelegate);
}

#pragma mark - CLLocationManagerDelegate
- (void)test_locationManagerDidDetermineStateForRegion_shouldNotifyScannerDelegate
{
	id mockCLBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
	
	OCMExpect([self.mockScannerDelegate deviceScaner:self.systemUnderTest
								   didDetermineState:CLRegionStateInside
										   forRegion:mockCLBeaconRegion]);
	
	[self.systemUnderTest locationManager:self.mockLocationManager
						didDetermineState:CLRegionStateInside
								forRegion:mockCLBeaconRegion];
	
	OCMVerifyAll(self.mockScannerDelegate);
}

- (void)test_locationManagerDidEnterRegion_ShouldNotifyScannerDelegate
{
	id mockCLBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
	
	OCMExpect([self.mockScannerDelegate deviceScaner:self.systemUnderTest
									  didEnterRegion:mockCLBeaconRegion]);
	
	[self.systemUnderTest locationManager:self.mockLocationManager
						   didEnterRegion:mockCLBeaconRegion];
	
	OCMVerifyAll(self.mockScannerDelegate);
}

- (void)test_locationManagerDidExitRegion_ShouldNotifyScannerDelegate
{
	id mockCLBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
	
	OCMExpect([self.mockScannerDelegate deviceScaner:self.systemUnderTest
									   didExitRegion:mockCLBeaconRegion]);
	
	[self.systemUnderTest locationManager:self.mockLocationManager
							didExitRegion:mockCLBeaconRegion];
	
	OCMVerifyAll(self.mockScannerDelegate);
}

- (void)test_locationManagerMonitoringDidFailForRegionWithError_ShouldNotifyScannerDelegate
{
	id mockCLBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
	id mockError = OCMStrictClassMock([NSError class]);
	
	OCMExpect([self.mockScannerDelegate deviceScaner:self.systemUnderTest
									didFailForRegion:mockCLBeaconRegion
										   withError:mockError]);
	
	[self.systemUnderTest locationManager:self.mockLocationManager
			   monitoringDidFailForRegion:mockCLBeaconRegion
								withError:mockError];
	
	OCMVerifyAll(self.mockScannerDelegate);
}

- (void)test_locationManagerDidChangeAuthorizationStatus_to_AuthorizedWhenInUse
{
	OCMExpect([self.mockSystem startMonitoringAllRegions]).andDo(nil);
	OCMExpect([self.mockLocationManager startUpdatingLocation]);
	
	[self.systemUnderTest locationManager:self.mockLocationManager
			 didChangeAuthorizationStatus:kCLAuthorizationStatusAuthorizedWhenInUse];
	
	OCMVerifyAll(self.mockSystem);
	OCMVerifyAll(self.mockLocationManager);
}

- (void)test_locationManagerDidChangeAuthorizationStatus_to_NotDetermined
{
	OCMExpect([[self.mockSystem reject] startMonitoringAllRegions]);
	OCMExpect([[self.mockLocationManager reject] startUpdatingLocation]);
	OCMExpect([self.mockLocationManager requestWhenInUseAuthorization]);
	
	[self.systemUnderTest locationManager:self.mockLocationManager
			 didChangeAuthorizationStatus:kCLAuthorizationStatusNotDetermined];
	
	OCMVerifyAll(self.mockSystem);
	OCMVerifyAll(self.mockLocationManager);
}

- (void)test_locationManagerDidRangeBeaconsInRegion_ShouldNotifyScannerDelegate
{
	id mockCLBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
	NSArray *testBeaconsArray = @[];
	
	OCMExpect([self.mockScannerDelegate deviceScaner:self.systemUnderTest
									 didRangeBeacons:testBeaconsArray
											inRegion:mockCLBeaconRegion]);
	
	[self.systemUnderTest locationManager:self.mockLocationManager
						  didRangeBeacons:testBeaconsArray
								 inRegion:mockCLBeaconRegion];
	
	OCMVerifyAll(self.mockScannerDelegate);
}

- (void)test_locationManagerRangingBeaconsDidFailForRegionWithError_ShouldNotifyScannerDelegate
{
	id mockCLBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
	id mockError = OCMStrictClassMock([NSError class]);
	
	OCMExpect([self.mockScannerDelegate deviceScaner:self.systemUnderTest
									didFailForRegion:mockCLBeaconRegion
										   withError:mockError]);
	
	[self.systemUnderTest locationManager:self.mockLocationManager
		   rangingBeaconsDidFailForRegion:mockCLBeaconRegion
								withError:mockError];
	
	OCMVerifyAll(self.mockScannerDelegate);
}

- (void)test_locationManagerDidFailWithError_ShouldNotifyScannerDelegate
{
	id mockError = OCMStrictClassMock([NSError class]);

	OCMExpect([self.mockScannerDelegate deviceScaner:self.systemUnderTest
						  didFailWithLocationManager:self.mockLocationManager
										   withError:mockError]);
	
	[self.systemUnderTest locationManager:self.mockLocationManager
						 didFailWithError:mockError];
	
	OCMVerifyAll(self.mockScannerDelegate);
}

#pragma mark - ButchersPersistanceEventDelegate
- (void)test_didSavedButcher
{
	OCMExpect([self.mockSystem startMonitoringAllRegions]);
	
	[self.systemUnderTest didSavedButcher];
	
	OCMVerifyAll(self.mockSystem);
}

- (void)test_didRemoveButcher
{
	OCMExpect([self.mockSystem startMonitoringAllRegions]);
	
	[self.systemUnderTest didRemoveButcher];
	
	OCMVerifyAll(self.mockSystem);
}

- (void)test_didRestoreDefaultButchers
{
	OCMExpect([self.mockSystem startMonitoringAllRegions]);
	
	[self.systemUnderTest didRestoreDefaultButchers];
	
	OCMVerifyAll(self.mockSystem);
}

@end
