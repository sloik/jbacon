//
//  JIAQualityView.m
//  jBacon
//
//  Created by Developer iOS on 31.10.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "JIAQualityView.h"

static CGFloat const kQualityViewIndycatorImageSpacing = 2;
static NSUInteger const kQualityViewIndycatorNumberOfViews = 3;

static CGFloat offAlpha             = 0.2;
static CGFloat onAlpha              = 1.0;
static NSTimeInterval animationTime = 1.0;

@interface JIAQualityView ()

@property (nonatomic, strong) UIImageView *indycatorTop;
@property (nonatomic, strong) UIImageView *indycatorMiddle;
@property (nonatomic, strong) UIImageView *indycatorBottom;

@end

@implementation JIAQualityView

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    
    if (self) {
        _indycatorImage = image;
        
        [self setup];
        
        _quality = JIAQualityViewQualityOff;
        [self updateQuality];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    _indycatorTop = [[UIImageView alloc] initWithImage:_indycatorImage];
    _indycatorMiddle = [[UIImageView alloc] initWithImage:_indycatorImage];
    _indycatorBottom = [[UIImageView alloc] initWithImage:_indycatorImage];
    
    [_indycatorTop setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_indycatorMiddle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_indycatorBottom setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:_indycatorTop];
    [self addSubview:_indycatorMiddle];
    [self addSubview:_indycatorBottom];
    
    [self setNeedsUpdateConstraints];
    [self invalidateIntrinsicContentSize];
}

- (void)setIndycatorImage:(UIImage *)indycatorImage
{
    _indycatorImage = indycatorImage;
    
    self.indycatorTop.image    = indycatorImage;
    self.indycatorMiddle.image = indycatorImage;
    self.indycatorBottom.image = indycatorImage;
    
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}

- (void)updateConstraints
{
    
    NSDictionary *views = @{
                            @"top"   : self.indycatorTop,
                            @"middle": self.indycatorMiddle,
                            @"bottom": self.indycatorBottom
                            };
    
    NSDictionary *metrics = @{ @"indycatorImageSpacing": @(kQualityViewIndycatorImageSpacing) };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[top]-(indycatorImageSpacing)-[middle]-(indycatorImageSpacing)-[bottom]|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    // align views to the left side
    [self alignViewToTheLeft:self.indycatorTop];
    [self alignViewToTheLeft:self.indycatorMiddle];
    [self alignViewToTheLeft:self.indycatorBottom];
    
    [super updateConstraints];
}

- (void)alignViewToTheLeft:(UIView *)viewToAlign
{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:viewToAlign
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    
    [self addConstraint:leftConstraint];
}

- (CGSize)intrinsicContentSize
{
    CGFloat height = self.indycatorImage.size.height * kQualityViewIndycatorNumberOfViews +
                     ((kQualityViewIndycatorNumberOfViews - 1) * kQualityViewIndycatorImageSpacing);
    
    return CGSizeMake(self.indycatorImage.size.width,
                      height);
}

#pragma mark - Setters

- (void)setQuality:(JIAQualityViewQuality)quality
{
    if (_quality != quality) {
        _quality = quality;
        [self updateQuality];
    }
}

- (void)updateQuality
{
    switch (self.quality) {
        case JIAQualityViewQualityOff:{
            [self animationsOff];
            break;
        }
            
        case JIAQualityViewQualityMinimum:{
            [self animationsMinimum];
            break;
        }
            
        case JIAQualityViewQualityMedium:{
            [self animationsMedium];
            break;
        }
            
        case JIAQualityViewQualityMaximum:{
            [self animationsMaximum];
            break;
        }
            
        default:{
            NSLog(@"%s\t :  Ups...", __PRETTY_FUNCTION__);
            break;
        }
    }
}

- (void)animationsOff
{
    [UIView animateWithDuration:animationTime
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.indycatorTop.alpha    = offAlpha;
                         self.indycatorMiddle.alpha = offAlpha;
                         self.indycatorBottom.alpha = offAlpha;
                     } completion:nil];
}

- (void)animationsMinimum
{
    [UIView animateWithDuration:animationTime
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.indycatorTop.alpha    = offAlpha;
                         self.indycatorMiddle.alpha = offAlpha;
                         self.indycatorBottom.alpha = onAlpha;
                     } completion:nil];
}

- (void)animationsMedium
{
    [UIView animateWithDuration:animationTime
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.indycatorTop.alpha    = offAlpha;
                         self.indycatorMiddle.alpha = onAlpha;
                         self.indycatorBottom.alpha = onAlpha;
                     } completion:nil];
}

- (void)animationsMaximum
{
    [UIView animateWithDuration:animationTime
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.indycatorTop.alpha    = onAlpha;
                         self.indycatorMiddle.alpha = onAlpha;
                         self.indycatorBottom.alpha = onAlpha;
                     } completion:nil];
}

@end
