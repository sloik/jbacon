//
//  BeaconRadar.m
//  jBeacon
//
//  Created by Developer iOS on 21.09.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import iAd;
@import CoreLocation;
@import CoreBluetooth;
@import TSMessages;

#import "BaconRadar.h"

#import "JIABaconHeaderCell.h"
#import "JIABaconInformationProvider.h"
#import "JIABaconInformationTVC.h"
#import "JIABaconQualityCell.h"
#import "JIABluetoothDeviceScanner.h"
#import "JIAConstants.h"
#import "ButchersListTVC.h"

static NSUInteger const kMaximumNotificatioCount = 2;

@interface BaconRadar () <InformationProviderNewContent, InformationProviderErrorListener, CBCentralManagerDelegate>

@property (nonatomic, strong) JIABaconInformationProvider *informationProvider;
@property (nonatomic, assign, getter=isDragging) BOOL draging;

@property (nonatomic, strong) CBCentralManager *bluetoothManager;
@property (nonatomic, assign) CBCentralManagerState oldBluetoothManagerState;

@property (nonatomic, assign) BOOL didShowMessage;
@property (nonatomic, weak) JIABaconInformationTVC *baconInformation;

@end

@implementation BaconRadar

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self showBaconMessage];
    });
    
    [self showBaconNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.informationProvider = [[JIABaconInformationProvider alloc] initWithTableView:self.tableView];
    self.informationProvider.contentListener = self;
    self.informationProvider.errorListener = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90.0;
    
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                 queue:dispatch_get_main_queue()];
    
    [TSMessage setDefaultViewController:self];
}

- (IBAction)addBaconButtonDidTaped:(id)sender
{
    [self performSegueWithIdentifier:kSegueShowButchers
                              sender:self];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.informationProvider allBeacons] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIDForBaconRadar
                                                            forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.draging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.draging = NO;
}

#pragma mark - Helper Methods

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    BOOL isBaconQualityCell = [cell isKindOfClass:[JIABaconQualityCell class]];
    NSAssert(isBaconQualityCell != NO, @"Nie ta klasa celki jest obslugiwana");
    
    JIABaconQualityCell *baconCell = (JIABaconQualityCell *)cell;
    JIABaconInformation *baconInfo = [self baconInformationForIndexPath:indexPath];
    
    baconCell.uuidLabel.text = baconInfo.uuid;
    baconCell.uuidLabel.text = baconInfo.name;
    baconCell.majorLabel.text = [baconInfo.major stringValue];
    baconCell.minorLabel.text = [baconInfo.minor stringValue];
    
    baconCell.qualityIndycator.quality = [self qualityViewQualityFromBaconProximity:baconInfo.proximity];
}

- (JIABaconInformation *)baconInformationForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *elementsArray = [self.informationProvider allBeacons];
    
    return elementsArray[indexPath.row];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kSegueShowBaconInformation
                              sender:[self baconInformationForIndexPath:indexPath]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    [TSMessage dismissActiveNotification];
    
    if ([segue.identifier isEqual:kSegueShowBaconInformation])
    {
        NSAssert([sender isKindOfClass:[JIABaconInformation class]] != NO, @"To powinien byc obiek opisujacy bekon,");
        
        JIABaconInformationTVC *destinationVC = segue.destinationViewController;
        destinationVC.bacon = (JIABaconInformation *)sender;
        
        self.baconInformation = destinationVC;
    }
}

#pragma mark - InformationProviderNewContent

- (void)informationProviderHasNewData:(JIABaconInformationProvider *)provider
{
    if (self.isDragging == NO) {
        
        NSArray *visibleCells = [self.tableView visibleCells];
        
        for (JIABaconQualityCell *cell in visibleCells) {
            
            NSIndexPath *path = [self.tableView indexPathForCell:cell];
            
            [self configureCell:cell
                    atIndexPath:path];
        }
        
        [self.baconInformation digestNewData:[provider allBeacons]];
    }
}

#pragma mark - InformationProviderErrorListener

- (void)informationProvider:(JIABaconInformationProvider *)provider
           didFailForRegion:(CLBeaconRegion *)region
                  withError:(NSError *)error
{
    NSUInteger messagesCount = [[TSMessage queuedMessages] count];
    if (messagesCount > kMaximumNotificatioCount) {
        return;
    }
    
    if ([error.domain isEqualToString:kCLErrorDomain]) {
        if (error.code == 16 ) {
            
            [TSMessage showNotificationWithTitle:@"Can't find any bacon..."
                                        subtitle:@"Please make sure you have bluetooth or location services enabled."
                                            type:TSMessageNotificationTypeError];
        }
    }
}

#pragma mark - Helper Methods

- (JIAQualityViewQuality)qualityViewQualityFromBaconProximity:(CLProximity)proximity
{
    NSDictionary *translationDictionary = @{
                                            @(CLProximityUnknown)   : @(JIAQualityViewQualityOff),
                                            @(CLProximityImmediate) : @(JIAQualityViewQualityMaximum),
                                            @(CLProximityNear)      : @(JIAQualityViewQualityMedium),
                                            @(CLProximityFar)       : @(JIAQualityViewQualityMinimum)
                                            };
    
    NSNumber *qualityAsNumber = translationDictionary[@(proximity)];
    
    return [qualityAsNumber unsignedIntegerValue];
}

- (void)showBaconNotification
{
    if ([[self.informationProvider allBeacons] count] == 0 &&
        self.bluetoothManager.state == CBCentralManagerStatePoweredOn &&
        self.didShowMessage != NO) {
        
        [self showBaconMessage];
    }
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        [TSMessage showNotificationWithTitle:@"Please enable location services or I will not be able to find any bacon for you :("
                                        type:TSMessageNotificationTypeWarning];
    }
    
    [self handleBlueToothNotifications];
}

- (void)showBaconMessage
{
    self.didShowMessage = YES;
    
    [TSMessage showNotificationWithTitle:@"Any found bacon will be displayed here :)"
                                    type:TSMessageNotificationTypeMessage];
}

- (void)handleBlueToothNotifications
{
    NSString *messageToDisplay = nil;
    TSMessageNotificationType notificationType = TSMessageNotificationTypeMessage;
    
    switch (self.bluetoothManager.state) {
            
        case CBCentralManagerStateResetting: {
            messageToDisplay = @"The connection with the system service was momentarily lost, update imminent.";
            notificationType = TSMessageNotificationTypeWarning;
            break;
        }
        case CBCentralManagerStateUnsupported: {
            messageToDisplay = @"The platform doesn't support Bluetooth Low Energy.";
            notificationType = TSMessageNotificationTypeError;
            break;
        }
        case CBCentralManagerStateUnauthorized: {
            messageToDisplay = @"The app is not authorized to use Bluetooth Low Energy.";
            notificationType = TSMessageNotificationTypeWarning;
            break;
        }
        case CBCentralManagerStatePoweredOff: {
            messageToDisplay = @"Bluetooth is currently powered off.";
            notificationType = TSMessageNotificationTypeWarning;
            break;
        }
        case CBCentralManagerStatePoweredOn: {
            
            if (self.oldBluetoothManagerState != CBCentralManagerStatePoweredOn) {
                [self showBaconMessage];
            }
            return;
        }
            
        default:{
            break;
        }
    }
    
    if (messageToDisplay) {
        [TSMessage showNotificationWithTitle:messageToDisplay
                                        type:notificationType];
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self handleBlueToothNotifications];
    
    self.oldBluetoothManagerState = central.state;
}

@end
