//
//  JIABaconInformationTests.m
//  jBacon
//
//  Created by Lukasz Stocki on 06.02.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "JIABaconInformation.h"

@interface JIABaconInformationTests : XCTestCase

@property (nonatomic, strong) JIABaconInformation *systemUnderTest;

@end

@implementation JIABaconInformationTests

- (void)setUp {
    [super setUp];

    self.systemUnderTest = [[JIABaconInformation alloc] init];
}

- (void)testNSCoding
{
    self.systemUnderTest.uuid = @"test uuid";
    self.systemUnderTest.name = @"test name";
    self.systemUnderTest.major = @100;
    self.systemUnderTest.minor = @10;
    
    NSData *encodedSystem = [NSKeyedArchiver archivedDataWithRootObject:self.systemUnderTest];
    JIABaconInformation *decodedSystem = [NSKeyedUnarchiver unarchiveObjectWithData:encodedSystem];
    
    BOOL areEqual = [self.systemUnderTest isEqual:decodedSystem];
    
    XCTAssertTrue(areEqual);
}

@end
