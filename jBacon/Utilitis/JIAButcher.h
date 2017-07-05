//
//  JIAButcher.h
//  jBacon
//
//  Created by Developer iOS on 01.12.2014.
//  Copyright (c) 2014 Developer iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JIAButcher : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uuid;

- (instancetype)initWithUUID:(NSString *)uuid
                        name:(NSString *)name NS_DESIGNATED_INITIALIZER;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToButcher:(JIAButcher *)butcher;

- (NSUInteger)hash;

@end
