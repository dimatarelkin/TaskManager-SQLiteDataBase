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
//entity name
static NSString * const kTaskEntityName = @"Tasks";
//Attributes
static NSString * const kTaskAttributeTitle = @"taskTitle";
static NSString * const kTaskAttributePriority = @"taskPriority";
static NSString * const kTaskAttributeAdditionalInfo = @"taskAdditionalInfo";
static NSString * const kTaskAttributeDate = @"taskDate";


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
-(void)addDataWith:(TaskObject *)data {

        NSEntityDescription *entityDescription =[NSEntityDescription entityForName:kTaskEntityName inManagedObjectContext:self.persistentContainer.viewContext];
    
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


-(void)updateData:(NSArray*)data {
    
}

-(void)deleteData:(TaskObject*)data {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kTaskEntityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iD == @%", data.iD];
    [fetchRequest setPredicate:predicate];
    
    [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil];
    [self.persistentContainer.viewContext deleteObject:data];
}


-(NSArray*)fetchAllDataTaskObjects {
    
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
                
                NSNumber *iD = manageObject.iD;
                NSString *title = manageObject.taskTitle;
                NSNumber *priority = manageObject.taskPriority;
                NSString *addInfo = manageObject.taskAdditionalInfo;
                NSDate *date = manageObject.taskDate;
                
                NSLog(@"\n ID - %@\n task title - %@\n priority - %@\n addInfo - %@\n date - %@", iD, title, priority, addInfo, [date description]);
                [manageObject.managedObjectContext deleteObject:manageObject];
                [self saveContext];
            }
        }
    }
    return results;
}



-(TaskObject*)fetchTaskObjectWithID:(NSNumber*)iD {
    
    TaskObject * task = [[TaskObject alloc] init];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kTaskEntityName];
    NSArray* allTasks;
    
    if (!fetchRequest) {
        NSLog(@"error with fetch request");
    } else {
        
        allTasks = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil];
        
        if (allTasks.count == 0) {
            NSLog(@"Context is empty");
            
        } else {
            for (Tasks *manageObject in allTasks) {
                
                if ([iD integerValue] == [manageObject.iD integerValue]) {
                    task.iD = manageObject.iD;
                    task.taskTitle = manageObject.taskTitle;
                    task.taskAdditionalInfo = manageObject.taskAdditionalInfo;
                    task.taskPriority = manageObject.taskPriority;
                    task.taskDate = manageObject.taskDate;
                }
            }
        }
    }
    return task;
}


@end
