//
//  JIABaconInformationProvider.h
//  jBacon
//
//  Created by Developer iOS on 30.10.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "JIABaconInformation.h"

#import "JIABluetoothDeviceScanner.h"

@class JIABaconInformationProvider;

@protocol InformationProviderNewContent <NSObject>

- (void)informationProviderHasNewData:(JIABaconInformationProvider *)provider;

@end

@protocol InformationProviderErrorListener <NSObject>

- (void)informationProvider:(JIABaconInformationProvider *)provider
           didFailForRegion:(CLBeaconRegion *)region
                  withError:(NSError *)error;

@end

/**
 *  Class for getting information about iBeacons.
 */
@interface JIABaconInformationProvider : NSObject

@property (nonatomic, weak) id <InformationProviderNewContent> contentListener;
@property (nonatomic, weak) id <InformationProviderErrorListener> errorListener;

@property (nonatomic, readonly, weak) UITableView *tableView;

- (instancetype)initWithTableView:(UITableView *)tableView ;
- (instancetype)initWithTableView:(UITableView *)tableView
                    deviceScanner:(JIABluetoothDeviceScanner *)deviceScanner NS_DESIGNATED_INITIALIZER;

- (NSArray *)allBeacons;

- (void)startLookingForBacon;

@end
