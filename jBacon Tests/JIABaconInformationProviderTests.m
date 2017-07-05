//
//  JIABaconInformationProviderTests.m
//  jBacon
//
//  Created by Developer iOS on 22.01.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "ButchersPersistance.h"
#import "JIABaconInformation.h"
#import "JIABaconInformationProvider.h"

@interface JIABaconInformationProvider (TESTS) <JIADeviceScanerDelegate>

@property (atomic, strong) NSMutableArray *bacons;
@property (nonatomic, strong) JIABluetoothDeviceScanner *deviceScaner;
@property (nonatomic, readwrite, weak) UITableView *tableView;

- (void)removeBaconInformationForRegion:(CLBeaconRegion *)region;
- (void)updateBacon:(CLBeacon *)bacon;
- (void)deleteRowsAtRemovedRows:(NSArray *)removedRows;
- (JIABaconInformation *)addNewBaconInformationFromBacon:(CLBeacon *)bacon
                                usingButchersPersistance:(ButchersPersistance *)butchersPersistance;
- (JIABaconInformation *)existingBaconInformationForBacon:(CLBeacon *)bacon;
- (void)updateExistingModelAndUIForBacon:(CLBeacon *)bacon;
- (void)sortBacons;
- (void)insertRowToTableViewForBaconInformation:(JIABaconInformation *)baconInformation;
- (JIABaconInformation *)baconInformationForBacon:(CLBeacon *)bacon;
- (NSIndexPath *)indexPathForBaconInformation:(JIABaconInformation *)bacon;

@end

@interface JIABaconInformationProviderTests : XCTestCase

@property (nonatomic, strong) JIABaconInformationProvider *systemUnderTest;

@property (nonatomic, strong) UITableView *mockTableView;
@property (nonatomic, strong) JIABluetoothDeviceScanner *mockBTDeviceScanner;
@property (nonatomic, weak) id <InformationProviderNewContent> mockContentListener;
@property (nonatomic, weak) id <InformationProviderErrorListener> mockErrorListener;

@end

@implementation JIABaconInformationProviderTests

- (void)setUp {
    [super setUp];
    
    self.mockTableView       = OCMStrictClassMock([UITableView class]);
    self.mockContentListener = OCMStrictProtocolMock(@protocol(InformationProviderNewContent));
    self.mockErrorListener   = OCMStrictProtocolMock(@protocol(InformationProviderErrorListener));
    
    self.mockBTDeviceScanner = OCMStrictClassMock([JIABluetoothDeviceScanner class]);
    OCMExpect([self.mockBTDeviceScanner setScanerDelegate:[OCMArg any]]);	// in init
    OCMExpect([self.mockBTDeviceScanner startMonitoringAllRegions]);		// in init
    
    
    self.systemUnderTest = [[JIABaconInformationProvider alloc] initWithTableView:self.mockTableView
                                                                    deviceScanner:self.mockBTDeviceScanner];
    
    self.systemUnderTest.contentListener = self.mockContentListener;
    self.systemUnderTest.errorListener   = self.mockErrorListener;
}

- (void)tearDown {
    self.mockTableView = nil;
    self.mockBTDeviceScanner = nil;
    self.systemUnderTest = nil;
    
    [super tearDown];
}

- (void)testStartLookingForBacon {
    
    OCMExpect([self.mockBTDeviceScanner startMonitoringAllRegions]);
    
    [self.systemUnderTest startLookingForBacon];
    
    OCMVerifyAll((id)self.mockBTDeviceScanner);
}

#pragma mark - JIABluetoothDeviceScanner
#pragma mark DeviceScaner:DidDetermineState:ForRegion
- (void)testDeviceScanerDidDetermineStateForRegionUnknown {
    // setup
    id mockBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    
    // expect
    OCMExpect([mockSystem removeBaconInformationForRegion:mockBeaconRegion]);
    
    //run the test
    [self.systemUnderTest deviceScaner:self.mockBTDeviceScanner
                     didDetermineState:CLRegionStateUnknown
                             forRegion:mockBeaconRegion];
    
    OCMVerifyAll(mockSystem);
    [mockSystem stopMocking];
}

- (void)testDeviceScanerDidDetermineStateForRegionOutside {
    // setup
    id mockBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    
    // expect
    OCMExpect([mockSystem removeBaconInformationForRegion:mockBeaconRegion]);
    
    //run the test
    [self.systemUnderTest deviceScaner:self.mockBTDeviceScanner
                     didDetermineState:CLRegionStateOutside
                             forRegion:mockBeaconRegion];
    
    OCMVerifyAll(mockSystem);
    [mockSystem stopMocking];
}

- (void)testDeviceScanerDidDetermineStateForRegionInside {
    // setup
    id mockBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    
    // expect
    OCMExpect([[mockSystem reject] removeBaconInformationForRegion:mockBeaconRegion]);
    
    //run the test
    [self.systemUnderTest deviceScaner:self.mockBTDeviceScanner
                     didDetermineState:CLRegionStateInside
                             forRegion:mockBeaconRegion];
    
    OCMVerifyAll(mockSystem);
    [mockSystem stopMocking];
}

#pragma mark deviceScaner:didExitRegion

- (void)testDeviceScanerDidExitRegion {
    // setup
    id mockBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    
    // expect
    OCMExpect([mockSystem removeBaconInformationForRegion:mockBeaconRegion]);
    
    
    // run
    [self.systemUnderTest deviceScaner:self.mockBTDeviceScanner
                         didExitRegion:mockBeaconRegion];
    
    // verify
    OCMVerifyAll(mockSystem);
    [mockSystem stopMocking];
}

#pragma mark deviceScaner:didRangeBeacons:inRegion

- (void)testDeviceScanerDidRangeBeaconsInRegion {
    // setup
    id mockBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    
    id mockBeacon = OCMStrictClassMock([CLBeacon class]);
    NSArray *rangedBeacons = @[mockBeacon];
    
    // expect
    OCMExpect([mockSystem updateBacon:mockBeacon]);
    OCMExpect([(id)self.mockContentListener informationProviderHasNewData:self.systemUnderTest]);
    
    // run
    [self.systemUnderTest deviceScaner:self.mockBTDeviceScanner
                       didRangeBeacons:rangedBeacons
                              inRegion:mockBeaconRegion];
    
    // verify
    OCMVerifyAll(mockSystem);
    OCMVerifyAll((id)self.mockContentListener);
    [mockSystem stopMocking];
}

#pragma mark deviceScaner:didRangeBeacons:inRegion
- (void)testDeviceScanerDidRangeBeaconsInRegion_NotifiesErrorListner
{
    id mockBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
    
    id mockError = OCMStrictClassMock([NSError class]);
    
    // expect
    OCMExpect([self.mockErrorListener informationProvider:self.systemUnderTest
                                         didFailForRegion:mockBeaconRegion
                                                withError:mockError]);
    
    // run
    [self.systemUnderTest deviceScaner:self.mockBTDeviceScanner
                      didFailForRegion:mockBeaconRegion
                             withError:mockError];
    
    // verify
    OCMVerifyAll((id)self.mockErrorListener);
}

#pragma mark deviceScaner:didStopMonitoringForRegion
- (void)testDeviceScanerDidStopMonitoringForRegion_ShouldRemoveBaconInformationForRegion
{
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    id mockBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
    
    OCMExpect([mockSystem removeBaconInformationForRegion:mockBeaconRegion]);
    
    [self.systemUnderTest deviceScaner:self.mockBTDeviceScanner
            didStopMonitoringForRegion:mockBeaconRegion];
    
    OCMVerifyAll(mockSystem);
    [mockSystem stopMocking];
}

#pragma mark - Helper methods
#pragma mark removeBaconInformationForRegion
- (void)testRemoveBaconInformationForRegion_ShouldRemoveAnyBaconInformationWithTheSameProximity
{
    // setup
    NSString *testUUID1 = @"UUID1";
    NSString *testUUID2 = @"UUID2";
    
    id mockBaconInformation1 = OCMStrictClassMock([JIABaconInformation class]);
    id mockBaconInformation2 = OCMStrictClassMock([JIABaconInformation class]);
    id mockBaconInformation3 = OCMStrictClassMock([JIABaconInformation class]);
    id mockBeaconRegion = OCMStrictClassMock([CLBeaconRegion class]);
    id mockUUID = OCMStrictClassMock([NSUUID class]);
    
    
    OCMStub([mockBaconInformation1 uuid]).andReturn(testUUID1);
    OCMStub([mockBaconInformation2 uuid]).andReturn(testUUID2);
    OCMStub([mockBaconInformation3 uuid]).andReturn(testUUID1);
    OCMStub([mockBeaconRegion proximityUUID]).andReturn(mockUUID);
    OCMStub([mockUUID UUIDString]).andReturn(testUUID1);
    
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    OCMStub([mockSystem deleteRowsAtRemovedRows:OCMOCK_ANY]).andDo(nil);
    
    NSMutableArray *beginArray = [NSMutableArray arrayWithArray:@[mockBaconInformation1, mockBaconInformation2, mockBaconInformation3]];
    
    NSMutableArray *expectedArray = [NSMutableArray arrayWithArray:@[mockBaconInformation2]];
    
    self.systemUnderTest.bacons = beginArray;
    
    // run
    [self.systemUnderTest removeBaconInformationForRegion:mockBeaconRegion];
    
    // verify
    BOOL arraysTheSame = [self.systemUnderTest.bacons isEqualToArray:expectedArray];
    BOOL theSameBaconInformation = (self.systemUnderTest.bacons.firstObject == mockBaconInformation2);
    
    XCTAssert(arraysTheSame);
    XCTAssert(theSameBaconInformation);
    
    // clean up
    [mockSystem stopMocking];
}

#pragma mark addNewBaconInformationFromBacon:usingButchersPersistance
- (void)testAddingNilBacon
{
    JIABaconInformation *returedInformation = [self.systemUnderTest addNewBaconInformationFromBacon:nil
                                                                           usingButchersPersistance:nil];
    
    XCTAssertTrue(returedInformation == nil);
}

- (void)testAddingValidBaconToModel
{
    // setup
    id mockUUID = OCMStrictClassMock([NSUUID class]);
    NSString *uuidAsString = @"test uuid as string";
    OCMStub([mockUUID UUIDString]).andReturn(uuidAsString);
    
    id mockBacon       = OCMStrictClassMock([CLBeacon class]);
    OCMStub([mockBacon proximityUUID]).andReturn(mockUUID);
    NSNumber *major = @100;
    OCMStub([mockBacon major]).andReturn(major);
    NSNumber *minor = @10;
    OCMStub([mockBacon minor]).andReturn(minor);
    
    id mockPersistance = OCMStrictClassMock([ButchersPersistance class]);
    NSString *butcherNameForUUID = @"butcherNameForUUID";
    OCMStub([mockPersistance butcherNameForUUID:uuidAsString]).andReturn(butcherNameForUUID);
    
    // run
    JIABaconInformation *returnedInformation = [self.systemUnderTest addNewBaconInformationFromBacon:mockBacon
                                                                            usingButchersPersistance:mockPersistance];
    
    // veryfy
    XCTAssertNotNil(returnedInformation);
    XCTAssertTrue([returnedInformation isKindOfClass:[JIABaconInformation class]]);
    
    JIABaconInformation *expectedInformation = [[JIABaconInformation alloc] initWithUUID:uuidAsString
                                                                                    name:butcherNameForUUID
                                                                                   major:major
                                                                                   minor:minor];
    
    XCTAssertTrue([returnedInformation isEqualToInformation:expectedInformation]);
    
    BOOL modelContainsInformation = [self.systemUnderTest.bacons containsObject:expectedInformation];
    XCTAssertTrue(modelContainsInformation);
}

#pragma mark updateBacon
- (void)testUpdateBacon_WithNewInformationForExistingBaconInformation
{
    // setup
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    id mockBacon = OCMStrictClassMock([CLBeacon class]);
    OCMStub([(CLBeacon *)mockBacon proximity]).andReturn(CLProximityFar);
    OCMStub([(CLBeacon *)mockBacon rssi]).andReturn(-100);
    OCMStub([(CLBeacon *)mockBacon accuracy]).andReturn(5);
    
    id mockBaconInformation = OCMClassMock([JIABaconInformation class]);
    
    OCMStub([mockSystem existingBaconInformationForBacon:mockBacon]).andReturn(mockBaconInformation).andDo(nil);
    
    // expect
    OCMExpect([self.mockContentListener informationProviderHasNewData:self.systemUnderTest]);
    
    // run
    [self.systemUnderTest updateBacon:mockBacon];
    
    // verify
    OCMVerify([self.mockContentListener informationProviderHasNewData:self.systemUnderTest]);
    
    // clean up
    [mockSystem stopMocking];
}

- (void)testUpdateBacon_WithTotalyNewBacon
{
    // setup
    id mockBacon = OCMStrictClassMock([CLBeacon class]);
    OCMStub([(CLBeacon *)mockBacon proximity]).andReturn(CLProximityFar);
    OCMStub([(CLBeacon *)mockBacon rssi]).andReturn(-100);
    OCMStub([(CLBeacon *)mockBacon accuracy]).andReturn(5);
    
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    OCMStub([mockSystem existingBaconInformationForBacon:mockBacon]).andReturn(nil).andDo(nil);
    
    OCMExpect([mockSystem updateExistingModelAndUIForBacon:mockBacon]).andDo(nil);
    
    // run
    [self.systemUnderTest updateBacon:mockBacon];
    
    // verify
    OCMVerifyAll(mockSystem);
    
    // cleanup
    [mockSystem stopMocking];
}

#pragma mark updateExistingModelAndUIForBacon
- (void)testUpdateExistingModelAndUIForBacon_ShouldSortTheModelAndUpdateUI
{
    // setup
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    id mockBacon = OCMStrictClassMock([CLBeacon class]);
    
    id mockPersistance = OCMStrictClassMock([ButchersPersistance class]);
    id classMockButchersPersistance = OCMStrictClassMock([ButchersPersistance class]);
    OCMStub([classMockButchersPersistance sharedButchers]).andReturn(mockPersistance);
    
    id mockBaconInformation = OCMStrictClassMock([JIABaconInformation class]);
    
    OCMStub([mockSystem addNewBaconInformationFromBacon:mockBacon
                               usingButchersPersistance:mockPersistance]).andReturn(mockBaconInformation);
    
    // run
    [mockSystem updateExistingModelAndUIForBacon:mockBacon];
    
    // verify
    OCMVerify([mockSystem sortBacons]);
    OCMVerify([mockSystem insertRowToTableViewForBaconInformation:mockBaconInformation]);
    
    // clean up
    [mockSystem stopMocking];
}

#pragma mark existingBaconInformationForBacon
- (void)testExistingBaconInformationForBacon_shouldUseHelperMethodToDoTheLookUp
{
    // setup
    id mockSystem = OCMPartialMock(self.systemUnderTest);
    id mockBacon = OCMStrictClassMock([CLBeacon class]);
    id mockBaconInformation = OCMStrictClassMock([JIABaconInformation class]);
    
    [[[mockSystem stub] andReturn:mockBaconInformation] baconInformationForBacon:mockBacon];
    
    // run
    id returnedBaconInformation = [self.systemUnderTest existingBaconInformationForBacon:mockBacon];
    
    // verify
    OCMVerify([mockSystem baconInformationForBacon:mockBacon]);
    XCTAssertEqual(returnedBaconInformation, mockBaconInformation);
    
    // clean up
    [mockSystem stopMocking];
}

#pragma mark baconInformationForBacon
- (void)testBaconInformationForBacon_ShouldReturnedBaconInformationForBacon
{
    // setup
    id mockBacon = OCMStrictClassMock([CLBeacon class]);
    id mockNSUUID = OCMStrictClassMock([NSUUID class]);
    OCMStub([mockBacon proximityUUID]).andReturn(mockNSUUID);
    
    NSString *mockNSUUIDAsString = @"Mock NSUUID as String";
    OCMStub([mockNSUUID UUIDString]).andReturn(mockNSUUIDAsString);
    
    NSNumber *testMajor = @(100);
    OCMStub([mockBacon major]).andReturn(testMajor);
    
    NSNumber *testMinor = @(10);
    OCMStub([mockBacon minor]).andReturn(testMinor);
    
    JIABaconInformation *testBaconInformation = [[JIABaconInformation alloc] initWithUUID:mockNSUUIDAsString
                                                                                     name:@""
                                                                                    major:testMajor
                                                                                    minor:testMinor];
    
    self.systemUnderTest.bacons = [NSMutableArray arrayWithArray:@[testBaconInformation]];
    
    // run
    JIABaconInformation *foundBaconInformation = [self.systemUnderTest baconInformationForBacon:mockBacon];
    
    
    // verify
    XCTAssertEqual(foundBaconInformation, testBaconInformation);
}

#pragma mark sortBacons
- (void)testSortBacons
{
    JIABaconInformation *info1 = [[JIABaconInformation alloc] initWithUUID:@"111"
                                                                      name:@"aaa"
                                                                     major:@100
                                                                     minor:@10];
    
    JIABaconInformation *info2 = [[JIABaconInformation alloc] initWithUUID:@"111"
                                                                      name:@"bbb"
                                                                     major:@100
                                                                     minor:@10];
    
    JIABaconInformation *info3 = [[JIABaconInformation alloc] initWithUUID:@"222"
                                                                      name:@"aaa"
                                                                     major:@100
                                                                     minor:@10];
    
    JIABaconInformation *info4 = [[JIABaconInformation alloc] initWithUUID:@"222"
                                                                      name:@"aaa"
                                                                     major:@200
                                                                     minor:@10];
    
    JIABaconInformation *info5 = [[JIABaconInformation alloc] initWithUUID:@"333"
                                                                      name:@"bbb"
                                                                     major:@300
                                                                     minor:@30];
    
    JIABaconInformation *info6 = [[JIABaconInformation alloc] initWithUUID:@"aaaa"
                                                                      name:@"zzzz"
                                                                     major:@1
                                                                     minor:@1];
    
    self.systemUnderTest.bacons = [NSMutableArray arrayWithArray:@[info3, info4, info1, info6, info5, info2]];
    
    [self.systemUnderTest sortBacons];
    
    NSArray *sortedArray = @[info1, info2, info3, info4, info5, info6];
    
    [sortedArray enumerateObjectsUsingBlock:^(JIABaconInformation *info, NSUInteger idx, BOOL *stop) {
        XCTAssertTrue([info isEqualToInformation:self.systemUnderTest.bacons[idx]]);
    }];
}

#pragma mark indexPathForBaconInformation
- (void)testIndexPathForBaconInformation_ShouldReturnCorrectIndexPathForExistingBaconInformation
{
    JIABaconInformation *info1 = [[JIABaconInformation alloc] initWithUUID:@"111"
                                                                      name:@"aaa"
                                                                     major:@100
                                                                     minor:@10];
    
    JIABaconInformation *info2 = [[JIABaconInformation alloc] initWithUUID:@"111"
                                                                      name:@"bbb"
                                                                     major:@100
                                                                     minor:@10];
    
    self.systemUnderTest.bacons = [NSMutableArray arrayWithArray:@[info1, info2]];
    
    NSIndexPath *returnedPath = [self.systemUnderTest indexPathForBaconInformation:info2];
    NSIndexPath *expectedPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    XCTAssertTrue([returnedPath isEqual:expectedPath]);
}

@end
