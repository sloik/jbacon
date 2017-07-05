//
//  JIAQualityView.h
//  jBacon
//
//  Created by Developer iOS on 31.10.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JIAQualityViewQuality) {

    JIAQualityViewQualityOff     = 0,
    JIAQualityViewQualityMinimum = 1,
    JIAQualityViewQualityMedium  = 2,
    JIAQualityViewQualityMaximum = 3
};

@interface JIAQualityView : UIView

@property (nonatomic, assign) JIAQualityViewQuality quality;
@property (nonatomic, strong) UIImage *indycatorImage;

- (instancetype)initWithImage:(UIImage *)image;


@end
