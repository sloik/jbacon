//
//  FryBaconFooterCell.m
//  jBacon
//
//  Created by Developer iOS on 02.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "FryBaconFooterCell.h"

@implementation FryBaconFooterCell

- (IBAction)buttonWasTaped
{
    if ([self.interactionDelegate respondsToSelector:@selector(userDidTapCallToActionButton)]) {
        [self.interactionDelegate userDidTapCallToActionButton];
    }
}

@end
