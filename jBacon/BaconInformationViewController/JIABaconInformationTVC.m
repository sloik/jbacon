//
//  JIABaconInformationTableViewController.m
//  jBacon
//
//  Created by Developer iOS on 01.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//


#import "JIABaconInformationTVC.h"

#import "JIAConstants.h"
#import "BaconInformationHeader.h"

static CGFloat const kBaconInformationHeaderHeight = 150;
static NSString *const kDefaultNoTitleMessage = @"No Title :(";
static NSString *const kDefaultNoValueMessage = @"No Value :(";

typedef NS_ENUM(NSInteger, JIABaconInformationRowType) {
    JIABaconInformationRowTypeUUID = 0,
    JIABaconInformationRowTypeName,
    JIABaconInformationRowTypeMajor,
    JIABaconInformationRowTypeMinor,
    JIABaconInformationRowTypeProximity,
    JIABaconInformationRowTypeAccuracy,
    JIABaconInformationRowTypeRSSI,
    JIABaconInformationRowTypeRowCount
};


@interface JIABaconInformationTVC ()

@end

@implementation JIABaconInformationTVC

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return JIABaconInformationRowTypeRowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDForBaconInformationSimpleCell
                                                            forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPatch:indexPath];
    
    return cell;
}

#pragma mark - Table View Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BaconInformationHeader *headerView = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDForBaconInformationHeader];
    
    headerView.backgroundImage.image = [UIImage imageNamed:@"PaperTileLarge"];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kBaconInformationHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return kBaconInformationHeaderHeight;
}

#pragma mark - Public API Calls
- (void)digestNewData:(NSArray *)allBacons
{
    [self.tableView reloadData];
}

#pragma mark - Helper Methods
- (void)configureCell:(UITableViewCell *)cell atIndexPatch:(NSIndexPath *)indexPath
{
    NSString *titleToSet = [self titleForIndexPath:indexPath];
    NSString *valueToSet = [self valueForIndexPath:indexPath];
    
    cell.textLabel.text = titleToSet;
    cell.detailTextLabel.text = valueToSet;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    
    NSDictionary *mapingDictionary = @{
                                       @(JIABaconInformationRowTypeUUID)      : @"UUID",
                                       @(JIABaconInformationRowTypeName)      : @"Name",
                                       @(JIABaconInformationRowTypeMajor)     : @"Major",
                                       @(JIABaconInformationRowTypeMinor)     : @"Minor",
                                       @(JIABaconInformationRowTypeProximity) : @"Proximity",
                                       @(JIABaconInformationRowTypeAccuracy)  : @"Accuracy",
                                       @(JIABaconInformationRowTypeRSSI)      : @"RSSI"
                                       };
    
    title = mapingDictionary[@(indexPath.row)];
    
    return title ?: kDefaultNoTitleMessage;
}

- (NSString *)valueForIndexPath:(NSIndexPath *)indexPath
{
    NSString *value = nil;
    
    switch (indexPath.row) {
            
        case JIABaconInformationRowTypeUUID:{
            value = self.bacon.uuid;
            break;
        }
            
        case JIABaconInformationRowTypeName:{
            value = self.bacon.name;
            break;
        }
            
        case JIABaconInformationRowTypeMajor:{
            value = self.bacon.major.stringValue;
            break;
        }
            
        case JIABaconInformationRowTypeMinor:{
            value = self.bacon.minor.stringValue;
            break;
        }
            
        case JIABaconInformationRowTypeProximity:{
            value = [self stringFromProximity:self.bacon.proximity];
            break;
        }
            
        case JIABaconInformationRowTypeAccuracy:{
            value = [self stringFromAccuracy:self.bacon.accuracy];
            break;
        }
            
        case JIABaconInformationRowTypeRSSI:{
            value = [self stringFromRSSI:self.bacon.rssi];
            break;
        }
            
        default:{
            value = nil;
            break;
        }
    }
    
    return value ?: kDefaultNoValueMessage;
}

- (NSString *)stringFromRSSI:(NSInteger)rssi
{
    return @(rssi).stringValue;
}

- (NSString *)stringFromProximity:(CLProximity)proximity
{
    NSDictionary *translationDictionary = @{ @(CLProximityUnknown)  : @"Unknown",
                                             @(CLProximityImmediate): @"Immediate",
                                             @(CLProximityNear)     : @"Near",
                                             @(CLProximityFar)      : @"Far"};
    
    return translationDictionary[@(proximity)];
}

- (NSString *)stringFromAccuracy:(CLLocationAccuracy)accuracy
{
    if (accuracy < 0) {
        return @"Unknown";
    }
    
    return [NSString stringWithFormat:@"%.3f meters", accuracy];
}

@end
