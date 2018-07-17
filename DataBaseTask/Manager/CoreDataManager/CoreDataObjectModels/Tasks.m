//
//  TaskManagedObject.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/17/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "Tasks.h"



//entity name
static NSString * const kTaskEntityName = @"Tasks";
//Attributes
static NSString * const kTaskID = @"iD";
static NSString * const kTaskAttributeTitle = @"taskTitle";
static NSString * const kTaskAttributePriority = @"taskPriority";
static NSString * const kTaskAttributeAdditionalInfo = @"taskAdditionalInfo";
static NSString * const kTaskAttributeDate = @"taskDate";



@implementation Tasks

@dynamic iD;
@dynamic taskTitle;
@dynamic taskAdditionalInfo;
@dynamic taskPriority;
@dynamic taskDate;


#pragma mark - Override Accessors

//0
- (void)setID:(NSNumber *)iD {
    [self willChangeValueForKey:kTaskID];
    [self setPrimitiveValue:iD forKey:kTaskID];
    [self didChangeValueForKey:kTaskID];
    NSLog(@"set taskID");
}


- (NSNumber *)iD {
    NSNumber* iD = nil;
    [self willAccessValueForKey:kTaskID];
    iD = [self primitiveValueForKey:kTaskID];
    [self didAccessValueForKey:kTaskID];
    NSLog(@"get taskID");
    
    return iD;
}

    

//1
-(void)setTaskTitle:(NSString *)taskTitle {
    
    [self willChangeValueForKey:kTaskAttributeTitle];
    [self setPrimitiveValue:taskTitle forKey:kTaskAttributeTitle];
    [self didChangeValueForKey:kTaskAttributeTitle];
    NSLog(@"set taskTitle");
}


-(NSString*)taskTitle {
    
    NSString* title = nil;
    [self willAccessValueForKey:kTaskAttributeTitle];
    title = [self primitiveValueForKey:kTaskAttributeTitle];
    [self didAccessValueForKey:kTaskAttributeTitle];
    NSLog(@"get title");
    
    return title;
}

//2
- (void)setTaskAdditionalInfo:(NSString *)taskAdditionalInfo {
    [self willChangeValueForKey:kTaskAttributeAdditionalInfo];
    [self setPrimitiveValue:taskAdditionalInfo forKey:kTaskAttributeAdditionalInfo];
    [self didChangeValueForKey:kTaskAttributeAdditionalInfo];
    NSLog(@"set taskAdditionalInfo");
}

- (NSString *)taskAdditionalInfo {
    NSString* info = nil;
    [self willAccessValueForKey:kTaskAttributeAdditionalInfo];
    info = [self primitiveValueForKey:kTaskAttributeAdditionalInfo];
    [self didAccessValueForKey:kTaskAttributeAdditionalInfo];
    NSLog(@"get taskAdditionalInfo");
    return info;
}


//3
- (void)setTaskPriority:(NSNumber*)taskPriority {
    [self willChangeValueForKey:kTaskAttributePriority];
    [self setPrimitiveValue:taskPriority forKey:kTaskAttributePriority];
    [self didChangeValueForKey:kTaskAttributePriority];
    NSLog(@"set taskPriority");
}

- (NSNumber*)taskPriority {
    NSNumber* priority = nil;
    [self willAccessValueForKey:kTaskAttributePriority];
    priority = [self primitiveValueForKey:kTaskAttributePriority];
    [self didAccessValueForKey:kTaskAttributePriority];
    NSLog(@"get taskPriority");
    return priority;
    
}


//4
- (void)setTaskDate:(NSDate *)taskDate {
    [self willChangeValueForKey:kTaskAttributeDate];
    [self setPrimitiveValue:taskDate forKey:kTaskAttributeDate];
    [self didChangeValueForKey:kTaskAttributeDate];
    NSLog(@"set taskDate");
}

- (NSDate *)taskDate {
    NSDate* date = nil;
    [self willAccessValueForKey:kTaskAttributeDate];
    date = [self primitiveValueForKey:kTaskAttributeDate];
    [self didAccessValueForKey:kTaskAttributeDate];
    NSLog(@"get taskDate");
    return date;
}


-(BOOL)validateValue:(id  _Nullable __autoreleasing *)value forKey:(NSString *)key error:(NSError * _Nullable __autoreleasing *)error {
    return YES;
}

-(BOOL)validateTaskTitle:(id  _Nullable __autoreleasing *)value forKey:(NSString *)key error:(NSError * _Nullable __autoreleasing *)error {
    
    *error = [NSError errorWithDomain:@"BAD TITLE" code:1 userInfo:nil];
    return NO;
}

@end
