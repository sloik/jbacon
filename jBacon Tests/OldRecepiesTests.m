//
//  OldRecepiesTests.m
//  jBacon
//
//  Created by Developer iOS on 11.02.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "OldRecepies.h"

#import "JIAOldRecepiesInformationManager.h"
#import "JIAConstants.h"
#import "OldRecepieHeaderCell.h"
#import "UIColor+JIABaconColors.h"
#import "OldRecepieFullInfoCell.h"

@interface OldRecepies (TESTS)

@property (nonatomic, weak) JIAOldRecepiesInformationManager *informationManager;

@end

@interface OldRecepiesTests : XCTestCase

@property (nonatomic, strong) OldRecepies *systemUnderTest;

@property (nonatomic, strong) JIAOldRecepiesInformationManager *mockInformationManager;
@property (nonatomic, strong) id mockTableView;
@property (nonatomic, strong) id mockInteractionDelegate;

@end

@implementation OldRecepiesTests

- (void)setUp {
    [super setUp];

	self.systemUnderTest = [OldRecepies new];
	
	self.mockTableView = OCMClassMock([UITableView class]);
	self.systemUnderTest.tableView = self.mockTableView;
	
	self.mockInformationManager = OCMStrictClassMock([JIAOldRecepiesInformationManager class]);
	self.systemUnderTest.informationManager = self.mockInformationManager;
	
	self.mockInteractionDelegate = OCMStrictProtocolMock(@protocol(OldRecepiesInteractionDelegate));
	self.systemUnderTest.interactionDelegate = self.mockInteractionDelegate;
}

- (void)test_whenViewDisapiers_itShouldSynchrnizeAllInformation
{
	OCMExpect([self.mockInformationManager synchronize]);
	
	[self.systemUnderTest viewDidDisappear:NO];
	
	OCMVerifyAll((id)self.mockInformationManager);
}

- (void)test_whenUserSelectsACell_thenInteractionDelegate_shouldBeNotified
{
	id mockOldRecepie = OCMStrictClassMock([JIAOldRecepie class]);
	NSArray *testOldRecepies = @[mockOldRecepie];
	
	NSIndexPath *testIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	
	OCMStub([self.mockInformationManager oldRecepies]).andReturn(testOldRecepies);
	
	OCMExpect([self.mockInteractionDelegate oldRecepies:self.systemUnderTest
									didSelectOldRecepie:mockOldRecepie]);
	
	OCMExpect([self.mockTableView deselectRowAtIndexPath:testIndexPath
												animated:YES]);
	
	[self.systemUnderTest tableView:self.mockTableView
			didSelectRowAtIndexPath:testIndexPath];
	
	OCMVerifyAll(self.mockTableView);
	OCMVerifyAll(self.mockInteractionDelegate);
}

@end
