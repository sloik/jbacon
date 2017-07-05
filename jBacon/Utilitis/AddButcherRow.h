//
//  AddButcherRow.h
//  jBacon
//
//  Created by Developer iOS on 12.01.2015.
//  Copyright (c) 2015 Developer iOS. All rights reserved.
//

@import UIKit;

#import "JIAConstants.h"

@interface AddButcherRow : NSObject

@property (nonatomic, copy) NSString *rowTitle;
@property (nonatomic, copy) NSString *valuePlaceholder;
@property (nonatomic, assign) JIAKeybordType keyboardType;

@end
