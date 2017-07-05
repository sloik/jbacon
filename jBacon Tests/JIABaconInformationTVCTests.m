//
//  JIABaconInformationTVCTests.m
//  jBacon
//
//  Created by Developer iOS on 10.02.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "JIABaconInformationTVC.h"

@interface JIABaconInformationTVCTests : XCTestCase

@property (nonatomic, strong) JIABaconInformationTVC *systemUnderTest;
@property (nonatomic, strong) id mockTableView;

@end

@implementation JIABaconInformationTVCTests

- (void)setUp {
    [super setUp];
	
	self.systemUnderTest = [JIABaconInformationTVC new];
	
	self.mockTableView = OCMClassMock([UITableView class]);
	self.systemUnderTest.tableView = self.mockTableView;
}

#pragma mark - Public API Calls
- (void)test_digestNewData
{
	OCMExpect([self.mockTableView reloadData]);
	
	[self.systemUnderTest digestNewData:nil];
	
	OCMVerifyAll(self.mockTableView);
}

@end
