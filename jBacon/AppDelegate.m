//
//  Created by Developer iOS on 21.09.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "AppDelegate.h"

#import "UIColor+JIABaconColors.h"
#import "ButchersPersistance.h"

@interface AppDelegate () 

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.tintColor = [UIColor defaultApplicationColor];
    
    [[ButchersPersistance sharedButchers] firsTimeRestore];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    application.idleTimerDisabled = NO;
}

@end
