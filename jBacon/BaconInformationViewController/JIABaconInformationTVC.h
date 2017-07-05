//
//  JIABaconInformationTableViewController.h
//  jBacon
//
//  Created by Developer iOS on 01.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import UIKit;

#import "JIABaconInformation.h"
#import "JIABaseTableViewController.h"

@interface JIABaconInformationTVC : JIABaseTableViewController

@property (nonatomic, strong) JIABaconInformation *bacon;

- (void)digestNewData:(NSArray *)allBacons;

@end
