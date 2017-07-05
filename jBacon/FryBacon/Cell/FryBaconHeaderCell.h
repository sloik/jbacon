//
//  FryBaconHeaderCell.h
//  jBacon
//
//  Created by Developer iOS on 02.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FryBaconHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *decorationImage;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end
