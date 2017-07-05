//
//  Created by Developer iOS on 10.12.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "NSString+JIAUUIDValidation.h"

@implementation NSString (JIAUUIDValidation)

- (BOOL)isValidUUIDString
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:self];
    
    if (uuid != nil) {
        return YES;
    }
    
    return NO;
}
@end
