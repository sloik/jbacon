//
//  JIABaconQualityCell.h
//  jBacon
//
//  Created by Developer iOS on 31.10.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JIAQualityView.h"

@interface JIABaconQualityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet JIAQualityView *qualityIndycator;

@property (nonatomic, weak) IBOutlet UILabel *uuidLabel;
@property (nonatomic, weak) IBOutlet UILabel *majorLabel;
@property (nonatomic, weak) IBOutlet UILabel *minorLabel;

@end
