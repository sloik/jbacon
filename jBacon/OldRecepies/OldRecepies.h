//
//  OldRecepies.h
//  jBacon
//
//  Created by Developer iOS on 05.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JIAOldRecepie.h"
#import "JIABaseTableViewController.h"

@class OldRecepies;

@protocol OldRecepiesInteractionDelegate <NSObject>

- (void)oldRecepies:(OldRecepies *)oldRecepies didSelectOldRecepie:(JIAOldRecepie *)oldRecepie;

@end


@interface OldRecepies : JIABaseTableViewController

@property (nonatomic, weak) id <OldRecepiesInteractionDelegate> interactionDelegate;

@end
