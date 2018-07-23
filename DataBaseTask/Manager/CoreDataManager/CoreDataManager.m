//
//  CoreDataManager.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/16/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "CoreDataManager.h"
#import "Tasks.h"
#import "TaskObject.h"


static NSString * const kCoreDataFileName = @"CoreDataTest";

@interface CoreDataManager ()
- (void)saveContext;
@end



@implementation CoreDataManager

#pragma mark - Core Data stack
@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:kCoreDataFileName];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}



#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



#pragma mark - ManagerProtocol Methods
-(void)addData:(TaskObject *)data {

        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kTaskEntityName inManagedObjectContext:self.persistentContainer.viewContext];
    
        if (!entityDescription) {
            NSLog(@"could not find entity description");
            return;
        }
    
        Tasks* manageObject = [[Tasks alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.persistentContainer.viewContext];
        manageObject.iD = data.iD;
        manageObject.taskTitle = data.taskTitle;
        manageObject.taskAdditionalInfo = data.taskAdditionalInfo;
        manageObject.taskPriority = data.taskPriority;
        manageObject.taskDate = data.taskDate;
    
    [self saveContext];
}


-(void)updateData:(TaskObject*)data {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kTaskEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iD == %@",data.iD];
    [fetchRequest setPredicate:predicate];
    Tasks* manageObject = [[self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil] firstObject];
    
        if ([data.iD integerValue] == [manageObject.iD integerValue]) {
            manageObject.iD = data.iD;
            manageObject.taskTitle = data.taskTitle;
            manageObject.taskAdditionalInfo = data.taskAdditionalInfo;
            manageObject.taskPriority = data.taskPriority;
            manageObject.taskDate = data.taskDate;
        }
    NSLog(@"man obj %@",manageObject.description);
    [self saveContext];
    NSLog(@"Task have been updated");
}




-(void)deleteData:(TaskObject*)data {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kTaskEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iD == %@",data.iD];
    [fetchRequest setPredicate:predicate];

    Tasks* managedObject = [[self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil] firstObject];
    NSLog(@"result = %@", [managedObject description]);
    if ([data.iD integerValue] == [managedObject.iD integerValue]) {
        [self.persistentContainer.viewContext deleteObject:managedObject];
        [self saveContext];
        NSLog(@"Task have been deleted");
    }
}


-(NSArray*)fetchAllDataTaskObjects {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kTaskEntityName];
    NSArray* results;
    NSMutableArray* tasks = [NSMutableArray array];
    
    if (!fetchRequest) {
        NSLog(@"error with fetch request");
    } else {
        results = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil];
        
        for (Tasks *manageObject in results) {
            TaskObject* task = [[TaskObject alloc] init];
            task.iD = manageObject.iD;
            task.taskTitle = manageObject.taskTitle;
            task.taskAdditionalInfo = manageObject.taskAdditionalInfo;
            task.taskPriority = manageObject.taskPriority;
            task.taskDate = manageObject.taskDate;
            [tasks addObject:task];
        }
        
        if (tasks.count == 0) {
            NSLog(@"Context is empty");
        } else {
            NSLog(@"All Tasks have been fetched");
            NSLog(@"fetch %@",[tasks componentsJoinedByString:@"-"]);
        }
    }
    return tasks;
}



-(TaskObject*)fetchTaskObjectWithID:(NSNumber*)iD {
    TaskObject * task = [[TaskObject alloc] init];
    NSArray *tasks = [self fetchAllDataTaskObjects];
    for (TaskObject* taskObj in tasks) {
        if ([iD integerValue] == [taskObj.iD integerValue]) {
            task = taskObj;
        }
    }
    return task;
}




- (void)deleteAllData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kTaskEntityName];
    NSArray* results;
    
    if (!fetchRequest) {
        NSLog(@"error with fetch request");
    } else {
        results = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil];
        if (results.count == 0) {
            NSLog(@"Context is empty");
        } else {
            for (Tasks *manageObject in results) {
                //cleaning context
                [manageObject.managedObjectContext deleteObject:manageObject];
                NSLog(@"Context have been cleaned");
            }
            [self saveContext];
        }
    }
}



@end
