//
//  BaconBrotcasterTests.m
//  jBacon
//
//  Created by Developer iOS on 09.02.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

@import CoreLocation;
@import CoreBluetooth;

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "BaconBrotcaster.h"

#import "JIAOldRecepiesInformationManager.h"

@interface BaconBrotcaster (TESTS) <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) JIAOldRecepiesInformationManager *informationManager;

- (void)idleTimeDisable;
- (void)startWorkingAsBacon;
- (void)stopAdvertising;
- (void)statAdevertasingWithPayload;
- (void)handleError;
- (CLBeaconRegion *)regionFromCurrentPayload;

@end

@interface BaconBrotcasterTests : XCTestCase

@property (nonatomic, strong) BaconBrotcaster *systemUnderTest;
@property (nonatomic, strong) id mockSystem;

@property (nonatomic, strong) id mockCBPeripheralManager;
@property (nonatomic, strong) id mockInformationManager;

@end

@implementation BaconBrotcasterTests

- (void)setUp {
    [super setUp];

	self.systemUnderTest = [BaconBrotcaster new];
	
	self.mockCBPeripheralManager = OCMStrictClassMock([CBPeripheralManager class]);
	self.systemUnderTest.peripheralManager = self.mockCBPeripheralManager;
	
	self.mockInformationManager = OCMStrictClassMock([JIAOldRecepiesInformationManager class]);
	self.systemUnderTest.informationManager = self.mockInformationManager;
	
	self.mockSystem = OCMPartialMock(self.systemUnderTest);
}

#pragma mark - Lfecycle
- (void)test_viewDidAppear
{
	OCMExpect([self.mockSystem idleTimeDisable]);
	OCMExpect([self.mockSystem startWorkingAsBacon]);
	
	[self.systemUnderTest viewDidAppear:YES];
	
	OCMVerifyAll(self.mockSystem);
}

- (void)test_viewDidLoad
{
	OCMExpect([self.mockCBPeripheralManager stopAdvertising]);
	
	[self.systemUnderTest viewDidLoad];
	
	OCMVerifyAll(self.mockCBPeripheralManager);
}

- (void)test_dealloc
{
	OCMExpect([self.systemUnderTest idleTimeDisable]);
    OCMExpect([self.systemUnderTest stopAdvertising]);

	self.systemUnderTest = nil;
	self.mockSystem = nil;
	
	OCMVerifyAll(self.mockSystem);
}

- (void)test_stopAdvertising
{
	OCMExpect([self.mockCBPeripheralManager stopAdvertising]);
	
	[self.systemUnderTest stopAdvertising];
	
	OCMVerifyAll(self.mockCBPeripheralManager);
}

#pragma mark - Setters & Getters
- (void)test_setBaconConfiguration_shouldStoreRecepieForBaconUsingInformationManager
{
	id mockBaconInformation = OCMStrictClassMock([JIABaconInformation class]);
	
	OCMExpect([self.mockInformationManager storeRecepieForBacon:mockBaconInformation]);
	
	[self.systemUnderTest setBaconConfiguration:mockBaconInformation];
	
	OCMVerifyAll(self.mockInformationManager);
}

#pragma mark - Brodcaster Functionality
#pragma mark Frying Bacon

- (void)test_startWorkingAsBacon_StatusPowerOn_ShouldStartAdvertising
{
	OCMStub([self.mockCBPeripheralManager state]).andReturn(CBPeripheralManagerStatePoweredOn);
	
	OCMExpect([self.mockSystem statAdevertasingWithPayload]);
	OCMExpect([[self.mockSystem reject] handleError]);
	
	[self.systemUnderTest startWorkingAsBacon];
	
	OCMVerifyAll(self.mockSystem);
}

- (void)test_startWorkingAsBacon_StatusOtherThenPowerOn_ShouldshowErrorMessage
{
	OCMStub([self.mockCBPeripheralManager state]).andReturn(CBPeripheralManagerStateUnknown);
	
	OCMExpect([[self.mockSystem reject] statAdevertasingWithPayload]);
	OCMExpect([self.mockSystem handleError]);
	
	[self.systemUnderTest startWorkingAsBacon];
	
	OCMVerifyAll(self.mockSystem);
}

- (void)test_statAdevertasingWithPayload_isAdvertising_shouldDoNothing
{
	OCMStub([self.mockCBPeripheralManager isAdvertising]).andReturn(YES);
	
	OCMExpect([[self.mockSystem reject] regionFromCurrentPayload]);
	OCMExpect([[self.mockCBPeripheralManager reject] startAdvertising:OCMOCK_ANY]);
	
	[self.systemUnderTest statAdevertasingWithPayload];
	
	OCMVerifyAll(self.mockSystem);
	OCMVerifyAll(self.mockCBPeripheralManager);
}

- (void)test_statAdevertasingWithPayload_isNoAdvertising_shouldStartAdvertising
{
	// setup
	OCMStub([self.mockCBPeripheralManager isAdvertising]).andReturn(NO);
	
	id mockRegion = OCMStrictClassMock([CLBeaconRegion class]);
	OCMStub([self.mockSystem regionFromCurrentPayload]).andReturn(mockRegion);
	
	id mockPeriperialData = @{};
	OCMStub([mockRegion peripheralDataWithMeasuredPower:OCMOCK_ANY]).andReturn(mockPeriperialData);
	
	// expectations
	OCMExpect([self.mockCBPeripheralManager startAdvertising:mockPeriperialData]);
	
	// run
	[self.systemUnderTest statAdevertasingWithPayload];
	
	// verify
	OCMVerifyAll(self.mockCBPeripheralManager);
}


@end
