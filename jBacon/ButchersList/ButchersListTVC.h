//
//  ButchersListTVCTableViewController.h
//  jBacon
//
//  Created by Developer iOS on 01.12.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

@import UIKit;

#import "JIABaseTableViewController.h"

@protocol ButchersListDataProvider <NSObject>

- (NSUInteger)numberOfButchers;

@end

@protocol ButchersListInteractionDelegate <NSObject>

- (void)removeButcher;

@end

@interface ButchersListTVC : JIABaseTableViewController

@property (nonatomic, weak) id <ButchersListDataProvider> dataProvider;
@property (nonatomic, weak) id <ButchersListInteractionDelegate> interactionDelegate;

@end
