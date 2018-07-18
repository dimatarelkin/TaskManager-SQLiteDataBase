//
//  TaskManagedObject.h
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/17/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//entity name
static NSString * const kTaskEntityName = @"Tasks";
//Attributes
static NSString * const kTaskID = @"iD";
static NSString * const kTaskAttributeTitle = @"taskTitle";
static NSString * const kTaskAttributePriority = @"taskPriority";
static NSString * const kTaskAttributeAdditionalInfo = @"taskAdditionalInfo";
static NSString * const kTaskAttributeDate = @"taskDate";


@interface Tasks : NSManagedObject

@property (strong, nonatomic) NSNumber* iD;
@property (strong, nonatomic) NSString *taskTitle;
@property (strong, nonatomic) NSString *taskAdditionalInfo;
@property (strong, nonatomic) NSNumber* taskPriority;
@property (strong, nonatomic) NSDate *taskDate;

@end
