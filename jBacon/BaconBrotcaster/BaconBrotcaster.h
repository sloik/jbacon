//
//  BeaconBrotcaster.h
//  jBeacon
//
//  Created by Developer iOS on 21.09.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JIABaconInformation.h"
#import "JIABaseViewController.h"

@interface BaconBrotcaster : JIABaseViewController

@property (nonatomic, strong) JIABaconInformation *baconConfiguration;

@end
