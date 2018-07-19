//
//  TaskObject.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/17/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "TaskObject.h"


static NSString * const kTaskIncrementorID = @"taskID";

@implementation TaskObject



- (NSString *)description {
    return [NSString stringWithFormat:@"\n ID - %@\n task title - %@\n priority - %@\n addInfo - %@\n date - %@",
                                     self.iD, self.taskTitle,
                                     self.taskPriority, self.taskAdditionalInfo,
                                    [self.taskDate description]];
}


- (instancetype)initWithId {
    self = [super init];
    if (self) {
        [self setID:[self newID]];
    }
    return self;
}

-(NSNumber*)newID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger current = [userDefaults integerForKey:kTaskIncrementorID];
    [userDefaults setInteger:current + 1 forKey:kTaskIncrementorID];
    [userDefaults synchronize];
    return [NSNumber numberWithInteger:current];
}

@end

