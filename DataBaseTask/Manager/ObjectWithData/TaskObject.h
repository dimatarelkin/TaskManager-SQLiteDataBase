//
//  TaskObject.h
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/17/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskObject : NSObject

@property (assign, nonatomic) NSNumber* iD;
@property (strong, nonatomic) NSString *taskTitle;
@property (strong, nonatomic) NSString *taskAdditionalInfo;
@property (assign, nonatomic) NSNumber* taskPriority;
@property (strong, nonatomic) NSDate *taskDate;

@end
