//
//  TaskObject.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/17/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "TaskObject.h"

@implementation TaskObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n ID - %@\n task title - %@\n priority - %@\n addInfo - %@\n date - %@",
                                       self.iD, self.taskTitle, self.taskPriority, self.taskAdditionalInfo, [self.taskDate description]];
}
@end

