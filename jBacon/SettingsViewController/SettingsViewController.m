//
//  Created by Developer iOS on 21.09.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import QuartzCore;

#import "SettingsViewController.h"
#import "ButchersPersistance.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

#pragma mark - User Interaction

- (IBAction)userDidTapRestoreButchers:(id)sender
{
    [self restoreInitialButchers];
}

#pragma mark - Helper Methods

- (void)restoreInitialButchers
{
    [[ButchersPersistance sharedButchers] restoreDefaultButchers];
    [[ButchersPersistance sharedButchers] synchronize];
    
    [self showConfirmationInformation];
}


- (void)showConfirmationInformation
{
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Initial Butchers", nil)
                                                                            message:NSLocalizedString(@"Factory settings has been restored :)", nil)
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                         [alerController dismissViewControllerAnimated:YES
                                                                                            completion:nil];
                                                     }];
    
    [alerController addAction:okAction];
    
    [self presentViewController:alerController
                       animated:YES
                     completion:nil];
}
@end
