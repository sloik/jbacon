//
//  Created by Developer iOS on 19.01.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "AppDelegate.h"
#import "UIColor+JIABaconColors.h"
#import "ButchersPersistance.h"


@interface AppDelegateTests : XCTestCase

@property (nonatomic, strong) id <UIApplicationDelegate> systemUnderTest;

@end

@implementation AppDelegateTests

- (void)setUp {
	[super setUp];
	
	self.systemUnderTest = [[AppDelegate alloc] init];
}

- (void)tearDown {
	self.systemUnderTest = nil;
	
	[super tearDown];
}

- (void)testApplication_DidFinishLaunchingWithOptions
{
	// setup
	id mockPersistance = [OCMockObject mockForClass:[ButchersPersistance class]];
	
	id classMock = OCMStrictClassMock([ButchersPersistance class]);
	
	OCMStub([classMock sharedButchers]).andReturn(mockPersistance);
	
	[[mockPersistance expect] firsTimeRestore];
	
	// method call
	[self.systemUnderTest application:nil didFinishLaunchingWithOptions:nil];
	
	[mockPersistance verify];
	[mockPersistance stopMocking];
}

- (void)testApplicationDidEnterBackground
{
	id mockApplication = OCMStrictClassMock([UIApplication class]);
	
	[[mockApplication expect] setIdleTimerDisabled:NO];
	
	
	[self.systemUnderTest applicationDidEnterBackground:mockApplication];
	
	[mockApplication verify];
}

- (void)testIdleTimerIsReenalbeldWhenGoingToBacground
{
	id mockUIApplication = OCMStrictClassMock([UIApplication class]);
	
	[[mockUIApplication expect] setIdleTimerDisabled:NO];
	
	[self.systemUnderTest applicationDidEnterBackground:mockUIApplication];
	
	[mockUIApplication verify];
}


@end
