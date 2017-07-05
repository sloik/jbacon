//
//  BeaconBrotcaster.m
//  jBeacon
//
//  Created by Developer iOS on 21.09.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import CoreLocation;
@import CoreBluetooth;

#import "BaconBrotcaster.h"

#import "JIAOldRecepiesInformationManager.h"

@interface BaconBrotcaster () <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) JIAOldRecepiesInformationManager *informationManager;

@end

@implementation BaconBrotcaster

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self idleTimeDisable];
    
    [self startWorkingAsBacon];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.informationManager = [JIAOldRecepiesInformationManager sharedManager];
	
    [self.peripheralManager stopAdvertising];
}

- (void)dealloc
{
    [self idleTimerEnable];
    [self stopAdvertising];
}

- (void)stopAdvertising
{
    [self.peripheralManager stopAdvertising];
}

#pragma mark - Setters & Getters

- (CBPeripheralManager *)peripheralManager
{
    @synchronized(self){
        if (_peripheralManager == nil) {
            _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                         queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        }
        
        return _peripheralManager;
    }
}

- (void)setBaconConfiguration:(JIABaconInformation *)baconConfiguration
{
    _baconConfiguration = baconConfiguration;
    
    [self.informationManager storeRecepieForBacon:baconConfiguration];
}

#pragma mark - Brodcaster Functionality
#pragma mark Frying Bacon

- (void)startWorkingAsBacon
{
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        [self statAdevertasingWithPayload];
    }
    else {
        [self handleError];
    }
}

- (void)handleError
{
    NSString *title = NSLocalizedString(@"Bluetooth must be enabled", @"");
    NSString *message = NSLocalizedString(@"To configure your device as a beacon", @"");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)statAdevertasingWithPayload
{
    if (self.peripheralManager.isAdvertising != NO) {
        // juz jestem bekonem nie musze byc raz drugi
        return;
    }
    
    // We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
    NSDictionary *peripheralData = nil;
    
	CLBeaconRegion *region = [self regionFromCurrentPayload];
	
    peripheralData = [region peripheralDataWithMeasuredPower:nil];
    
    // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
    if(peripheralData)
    {
        [self.peripheralManager startAdvertising:peripheralData];
    }
}

- (CLBeaconRegion *)regionFromCurrentPayload
{
	NSUUID *uuid = [self uuidFromCurrentBaconConfiguration];
	
	CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
																	 major:[self.baconConfiguration.major shortValue]
																	 minor:[self.baconConfiguration.minor shortValue]
																identifier:self.baconConfiguration.name];
	
	return region;
}

- (NSUUID *)uuidFromCurrentBaconConfiguration
{
	NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:self.baconConfiguration.uuid];
	
	return uuid;
}

#pragma mark CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // it's required by the protocol
}

#pragma  mark - Idle timer

/**
 *  Helper method to enable idle timer.
 */
- (void)idleTimerEnable
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

/**
 *  Helper method to disable idle timer.
 */
- (void)idleTimeDisable
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

@end
