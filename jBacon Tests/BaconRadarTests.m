//
//  BaconRadarTests.m
//  jBacon
//
//  Created by Developer iOS on 11.02.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

@import iAd;
@import CoreLocation;
@import CoreBluetooth;

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "BaconRadar.h"

#import "JIABaconHeaderCell.h"
#import "JIABaconInformationProvider.h"
#import "JIABaconInformationTVC.h"
#import "JIABaconQualityCell.h"
#import "JIABluetoothDeviceScanner.h"
#import "JIAConstants.h"
#import "ButchersListTVC.h"

@interface BaconRadar (TESTS) <InformationProviderNewContent, InformationProviderErrorListener, CBCentralManagerDelegate>

@property (nonatomic, strong) JIABaconInformationProvider *informationProvider;
@property (nonatomic, assign, getter=isDragging) BOOL draging;

@property (nonatomic, strong) CBCentralManager *bluetoothManager;
@property (nonatomic, assign) CBCentralManagerState oldBluetoothManagerState;

@property (nonatomic, assign) BOOL didShowMessage;
@property (nonatomic, weak) JIABaconInformationTVC *baconInformation;

@end

@interface BaconRadarTests : XCTestCase

@property (nonatomic, strong) BaconRadar *systemUnderTest;

@end

@implementation BaconRadarTests

- (void)setUp {
    [super setUp];

	self.systemUnderTest = [BaconRadar new];
}

@end
