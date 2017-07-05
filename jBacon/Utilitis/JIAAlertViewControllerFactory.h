//
//  Created by Developer iOS on 16.12.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface JIAAlertViewControllerFactory : NSObject

+ (UIAlertController *)alertControllerWithDefayultOkActionWithTitle:(NSString *)title
                                                            message:(NSString *)message;

+ (UIAlertController *)alertControllerWithDefayultOkActionWithTitle:(NSString *)title
                                                            message:(NSString *)message
                                                    okActionHandler:(void (^)(UIAlertAction *action))handler;

@end
