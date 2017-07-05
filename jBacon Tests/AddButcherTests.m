//
//  AddButcherTests.m
//  jBacon
//
//  Created by Developer iOS on 03.02.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "AddButcher.h"
#import "AddButcherRow.h"
#import "ButchersPersistance.h"

@interface AddButcher (TESTS)

@property (nonatomic, strong) NSArray *rows;

- (void)setupRows;
- (BOOL)checkForCorrectUUIDString;
- (IBAction)userDidPressSaveButton:(id)sender;
- (void)handleUUIDErrorNotCorrectString;
- (BOOL)checkForCorrectName;
- (void)handleNameErrorNotCorrectNameString;
- (void)handleCorrectUUID;
- (void)gatherBaconInformationAndAddBaconRegion;
- (NSString *)gatherUUIDFromTableView;
- (NSString *)gatherNameFromTableView;
- (UIKeyboardType)keyboardTypeFromBaconRow:(AddButcherRow *)baconRow;

@end

@interface AddButcherTests : XCTestCase

@property (nonatomic, strong) AddButcher *systemUnderTest;

@end

@implementation AddButcherTests

- (void)setUp {
    [super setUp];
	
	self.systemUnderTest = [AddButcher new];
}

#pragma mark - LifeCycle
- (void)testViewDidLoad
{
	id system = OCMPartialMock(self.systemUnderTest);
	OCMExpect([system setupRows]);
	
	[self.systemUnderTest viewDidLoad];
	[system verify];
	[system stopMocking];
}

#pragma mark - Setup
- (void)testSetupRows
{
	[self.systemUnderTest setupRows];
	
	for (id row in self.systemUnderTest.rows) {
		XCTAssertTrue([row isKindOfClass:[AddButcherRow class]], @"This should be a AddButcherRow");
	}
}

#pragma mark - Actions
- (void)testUserDidPressSaveButtonWrongUUID
{
    id system = OCMPartialMock(self.systemUnderTest);
    OCMStub([system checkForCorrectUUIDString]).andReturn(NO);
    
    [self.systemUnderTest userDidPressSaveButton:nil];
    
    OCMVerify([system handleUUIDErrorNotCorrectString]);
    OCMVerify([[system reject] handleCorrectUUID]);
    [system stopMocking];
}

- (void)testUserDidPressSaveButtonGoodUUIDWrongName
{
    id system = OCMPartialMock(self.systemUnderTest);
    OCMStub([system checkForCorrectUUIDString]).andReturn(YES);
    OCMStub([system checkForCorrectName]).andReturn(NO);
    
    [self.systemUnderTest userDidPressSaveButton:nil];

    OCMVerify([[system reject] handleUUIDErrorNotCorrectString]);
    OCMVerify([system handleNameErrorNotCorrectNameString]);
    OCMVerify([[system reject] handleCorrectUUID]);
    [system stopMocking];
}

- (void)testUserDidPressSaveButtonGoodUUIDGOODName
{
    id system = OCMPartialMock(self.systemUnderTest);
    OCMStub([system checkForCorrectUUIDString]).andReturn(YES);
    OCMStub([system checkForCorrectName]).andReturn(YES);
    
    OCMStub([system handleCorrectUUID]).andDo(nil); // stubs the selection
    [self.systemUnderTest userDidPressSaveButton:nil];
    
    OCMVerify([[system reject] handleUUIDErrorNotCorrectString]);
    OCMVerify([[system reject] handleNameErrorNotCorrectNameString]);
    
    // this works when code is comented but reject dos not make the test fail... ocm magic
    OCMVerify([system  handleCorrectUUID]);
    [system stopMocking];
}

- (void)testHandleCorrectUUID
{
    id system = OCMPartialMock(self.systemUnderTest);
    OCMStub([system gatherNameFromTableView]).andReturn(@"Unique Name");
    OCMStub([system gatherUUIDFromTableView]).andReturn(@"12345678-1234-1234-1234-123456789012");
    
    id mockPersistance = [OCMockObject mockForClass:[ButchersPersistance class]];
    id classMock = OCMStrictClassMock([ButchersPersistance class]);
    OCMStub([classMock sharedButchers]).andReturn(mockPersistance);
    
    OCMExpect([mockPersistance saveButcher:[OCMArg isKindOfClass:[JIAButcher class]]]);
    OCMExpect([(ButchersPersistance*)mockPersistance synchronize]);
    
    [self.systemUnderTest handleCorrectUUID];
    
    OCMVerifyAll(mockPersistance);
    OCMVerify([system gatherBaconInformationAndAddBaconRegion]);
    [system stopMocking];
}

#pragma mark - Helper methods
- (void)testCheckForCorrectNameWhenNil
{
    id system = OCMPartialMock(self.systemUnderTest);
    OCMStub([system gatherNameFromTableView]).andReturn(nil);
    
    BOOL returnedValue = [self.systemUnderTest checkForCorrectName];
    
    XCTAssertTrue(returnedValue == NO, @"Should return NO");
    
    [system stopMocking];
}

- (void)testCheckForCorrectNameWhenEmptyString
{
    id system = OCMPartialMock(self.systemUnderTest);
    OCMStub([system gatherNameFromTableView]).andReturn(@"");
    
    BOOL returnedValue = [self.systemUnderTest checkForCorrectName];
    
    XCTAssertTrue(returnedValue == NO, @"Should return NO");
    
    [system stopMocking];
}

- (void)testCheckForCorrectNameWhenNameIsValid
{
    id system = OCMPartialMock(self.systemUnderTest);
    OCMStub([system gatherNameFromTableView]).andReturn(@"Valid Name");
    
    BOOL returnedValue = [self.systemUnderTest checkForCorrectName];
    
    XCTAssertTrue(returnedValue == YES, @"Should return YES");
    
    [system stopMocking];
}

- (void)testGatherBaconInformationAndAddBaconRegion
{
    id system = OCMPartialMock(self.systemUnderTest);
    OCMStub([system gatherNameFromTableView]).andReturn(@"Unique Name");
    OCMStub([system gatherUUIDFromTableView]).andReturn(@"12345678-1234-1234-1234-123456789012");
    
    id mockPersistance = [OCMockObject mockForClass:[ButchersPersistance class]];
    id classMock = OCMStrictClassMock([ButchersPersistance class]);
    OCMStub([classMock sharedButchers]).andReturn(mockPersistance);
    
    OCMExpect([mockPersistance saveButcher:[OCMArg isKindOfClass:[JIAButcher class]]]);
    OCMExpect([(ButchersPersistance*)mockPersistance synchronize]);
    
    [self.systemUnderTest gatherBaconInformationAndAddBaconRegion];
    
    OCMVerifyAll(mockPersistance);
    [system stopMocking];
}

- (void)testKeyboardTypeFromBaconRow_Numbers
{
    id mockAddButcherRow = OCMClassMock([AddButcherRow class]);
    OCMStub([mockAddButcherRow keyboardType]).andReturn(JIAKeybordTypeNumbers);
    UIKeyboardType kbType = [self.systemUnderTest keyboardTypeFromBaconRow:mockAddButcherRow];
    
    XCTAssertTrue(kbType == UIKeyboardTypeNumbersAndPunctuation);
}

- (void)testKeyboardTypeFromBaconRow_Text
{
    id mockAddButcherRow = OCMClassMock([AddButcherRow class]);
    OCMStub([mockAddButcherRow keyboardType]).andReturn(JIAKeybordTypeText);
    UIKeyboardType kbType = [self.systemUnderTest keyboardTypeFromBaconRow:mockAddButcherRow];
    
    XCTAssertTrue(kbType == UIKeyboardTypeASCIICapable);
}

- (void)testKeyboardTypeFromBaconRow_Default
{
    id mockAddButcherRow = OCMClassMock([AddButcherRow class]);
    OCMStub([mockAddButcherRow keyboardType]).andReturn(JIAKeybordTypeUnknown);
    UIKeyboardType kbType = [self.systemUnderTest keyboardTypeFromBaconRow:mockAddButcherRow];
    
    XCTAssertTrue(kbType == UIKeyboardTypeDefault);
}

@end
