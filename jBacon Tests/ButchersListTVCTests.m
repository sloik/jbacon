//
//  Created by Developer iOS on 11.02.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "ButchersListTVC.h"

#import "JIAConstants.h"
#import "ButchersPersistance.h"

@interface ButchersListTVC (TESTS)

@property (nonatomic, strong) ButchersPersistance *butcherPersistance;

- (void)updateTableView:(UITableView *)tableView
withDeleteRowsAtIndexPaths:(NSArray *)deletedRows;
- (JIAButcher *)butcherForIndexPatch:(NSIndexPath *)indexPath;

@end

@interface ButchersListTVCTests : XCTestCase

@property (nonatomic, strong) ButchersListTVC *systemUnderTest;
@property (nonatomic, strong) id mockTableView;
@property (nonatomic, strong) id mockButcherPersistance;

@end

@implementation ButchersListTVCTests

- (void)setUp {
    [super setUp];

	self.mockTableView = OCMClassMock([UITableView class]);
	self.mockButcherPersistance = OCMStrictClassMock([ButchersPersistance class]);
	
	self.systemUnderTest = [ButchersListTVC new];
	self.systemUnderTest.tableView = self.mockTableView;
	self.systemUnderTest.butcherPersistance = self.mockButcherPersistance;
}

- (void)test_viewWillAppear_shouldReloadData
{
	OCMExpect([self.mockTableView reloadData]);
	
	[self.systemUnderTest viewWillAppear:YES];
	
	OCMVerifyAll(self.mockTableView);
}

#pragma mark - Table view data source
- (void)test_numberOfRowsInSection_shouldTakeTheCountOfKnownButchers
{
	OCMExpect([self.mockButcherPersistance knownButchers]);
	
	[self.systemUnderTest tableView:self.mockTableView
			  numberOfRowsInSection:0];
	
	OCMVerifyAll(self.mockButcherPersistance);
}

- (void)test_tableView_commitEditingStyle_forRowAtIndexPath_SytleDelete_shouldRemoveButcher
{
	id mockButcher = OCMStrictClassMock([JIAButcher class]);
	
	id nicePersistance = OCMClassMock([ButchersPersistance class]);
	self.systemUnderTest.butcherPersistance = nicePersistance;
	
	OCMExpect([nicePersistance removeButcher:mockButcher]);
	OCMExpect([(ButchersPersistance *)nicePersistance synchronize]);
	
	id mockIndexPath = OCMStrictClassMock([NSIndexPath class]);
	
	id mockSystem = OCMPartialMock(self.systemUnderTest);
	OCMStub([mockSystem updateTableView:OCMOCK_ANY
			 withDeleteRowsAtIndexPaths:OCMOCK_ANY]).andDo(nil);
	OCMStub([mockSystem butcherForIndexPatch:mockIndexPath]).andReturn(mockIndexPath);
	
	[mockSystem tableView:self.mockTableView
	   commitEditingStyle:UITableViewCellEditingStyleDelete
		forRowAtIndexPath:mockIndexPath];
	
	OCMVerifyAll(self.mockButcherPersistance);
	
	[mockSystem stopMocking];
}


@end
