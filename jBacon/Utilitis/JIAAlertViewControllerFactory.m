//
//  Created by Developer iOS on 16.12.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "JIAAlertViewControllerFactory.h"

@implementation JIAAlertViewControllerFactory

+ (UIAlertController *)alertControllerWithDefayultOkActionWithTitle:(NSString *)title
                                                            message:(NSString *)message
{
    return [self alertControllerWithDefayultOkActionWithTitle:title
                                                      message:message
                                              okActionHandler:nil];
}

+ (UIAlertController *)alertControllerWithDefayultOkActionWithTitle:(NSString *)title
                                                            message:(NSString *)message
                                                    okActionHandler:(void (^)(UIAlertAction *action))handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:handler];
    
    [alertController addAction:okAction];
    
    return alertController;
}

@end
