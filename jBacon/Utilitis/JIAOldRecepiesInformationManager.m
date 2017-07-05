//
//  JIAOldRecepiesInformationProvider.m
//  jBacon
//
//  Created by Developer iOS on 05.11.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import "JIAOldRecepiesInformationManager.h"

static NSString *const kRecepiesUserDefaultsKey = @"kRecepiesUserDefaultsKey";
static NSUInteger const kRecepiesOldRecepiesMaximumCount = 20;

@interface JIAOldRecepiesInformationManager ()

@property (nonatomic, strong) NSMutableArray *recepies;

@end

@implementation JIAOldRecepiesInformationManager

+ (instancetype)sharedManager
{
    static JIAOldRecepiesInformationManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [JIAOldRecepiesInformationManager new];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _recepies = [self loadFromSavedFile];
    }
    return self;
}

- (void)dealloc
{
    [self saveToFile];
}

- (NSArray *)oldRecepies
{
    return [NSArray arrayWithArray:self.recepies];
}

- (JIABaconInformation *)newestBacon
{
    JIAOldRecepie *oldRecepie = [self.recepies firstObject];
    
    return oldRecepie.baconInformation;
}

- (void)storeRecepieForBacon:(JIABaconInformation *)bacon
{
    // Update bacon recepie if it was found
    __block BOOL didFoundRecepie = NO;
    
    [self.oldRecepies enumerateObjectsWithOptions:NSEnumerationConcurrent
                                       usingBlock:^(JIAOldRecepie *oldRecepie, NSUInteger idx, BOOL *stop)
    {
        if ([oldRecepie.baconInformation isEqualToInformation:bacon] == YES) {
            *stop = YES;
            didFoundRecepie = YES;
            
            oldRecepie.addingTime = [NSDate date];
        }
    }];
    
    // add taht bacon as a new recepie
    if (didFoundRecepie == NO) {
        
        JIAOldRecepie *oldRecepie = [[JIAOldRecepie alloc] initWithBaconInformation:bacon
                                                                         addingTime:[NSDate date]];
        
        [self.recepies insertObject:oldRecepie atIndex:0];
    }
    
    [self sortRecepiesByAddedDate];
}

- (NSUInteger)recepiesCount
{
    return [self.recepies count];
}

- (void)sortRecepiesByAddedDate
{
    [self.recepies sortUsingComparator:^NSComparisonResult(JIAOldRecepie *oldRecepieLeft,
                                                           JIAOldRecepie *oldRecepieRight)
     {
         NSComparisonResult result = [oldRecepieLeft.addingTime compare:oldRecepieRight.addingTime];
         
         // flips the result
         switch (result) {
             case NSOrderedAscending:{
                 return NSOrderedDescending;
             }
                 
             case NSOrderedDescending:{
                 return NSOrderedAscending;
             }
                 
             default:{
                 return result;
             }
         }
     }];
}

- (void)synchronize
{
    [self sortRecepiesByAddedDate];
    [self saveToFile];
}

#pragma mark - Plisting and DePelisting

- (NSMutableArray *)loadFromSavedFile
{
    NSData *archivedRecepies = [[NSUserDefaults standardUserDefaults] dataForKey:kRecepiesUserDefaultsKey];
    NSArray *recepies = archivedRecepies ? [NSKeyedUnarchiver unarchiveObjectWithData:archivedRecepies] : nil;
    
    return recepies ? [NSMutableArray arrayWithArray:recepies] : [NSMutableArray new];
}

- (void)saveToFile
{
    [self cutOffArray];
    
    NSData *archivedRecepies = [NSKeyedArchiver archivedDataWithRootObject:self.recepies];
    
    [[NSUserDefaults standardUserDefaults] setObject:archivedRecepies
                                              forKey:kRecepiesUserDefaultsKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cutOffArray
{
    if (self.recepiesCount > kRecepiesOldRecepiesMaximumCount) {
        [self.recepies removeObjectsInRange:NSMakeRange(kRecepiesOldRecepiesMaximumCount,
                                                        self.recepiesCount - kRecepiesOldRecepiesMaximumCount)];
    }
}



@end
