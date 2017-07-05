//
//  Created by Developer iOS on 30.10.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import Foundation;

#pragma mark - Enums

typedef NS_ENUM(NSUInteger, JIAKeybordType) {
    JIAKeybordTypeUnknown = 0,
    JIAKeybordTypeText    = 1,
    JIAKeybordTypeNumbers = 2
};

#pragma mark - StoryBoard Cell Resuse ID
extern NSString *const kCellReuseIDForBaconRadar;
extern NSString *const kCellReuseIDForBaconInformationSimpleCell;
extern NSString *const kCellReuseIDForBaconInformationHeader;

#pragma mark - Fry Section
extern NSString *const kCellReuseIDForFryBaconHeader;
extern NSString *const kCellReuseIDForFryBaconFooter;
extern NSString *const kCellReuseIDForFrySimpleInformation;

#pragma mark - Old Recepie
extern NSString *const kCellReuseIDForOldRecepieHeaderCell;
extern NSString *const kCellReuseIDForOldRecepieFullInfoCell;

#pragma mark - Add Bacon
extern NSString *const kCellReuseIDForAddBaconCell;
extern NSString *const kCellReuseIDForAddBaconHeader;

#pragma mark - Btchers List
extern NSString *const kCellReuseIDForButcherListInfoCell;

#pragma mark - Seguey Identifiers
extern NSString *const kSegueShowBrotcaster;
extern NSString *const kSegueShowBaconInformation;
extern NSString *const kSegueShowOldRecepies;
extern NSString *const kSegueShowAddButcher;
extern NSString *const kSegueShowButchers;
