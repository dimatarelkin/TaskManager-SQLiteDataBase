//
//  AppDelegate.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/9/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "AppDelegate.h"

#import "CoreDataManager.h"
#import "TaskObject.h"



@interface AppDelegate ()

@end


@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.


    TaskObject* task = [[TaskObject alloc] init];
    task.iD = @1;
    task.taskTitle = @"Some Title";
    task.taskAdditionalInfo = @"task addd info";
    task.taskPriority = @1;
    task.taskDate = [NSDate date];
    
    TaskObject* task2 = [[TaskObject alloc] init];
    task2.iD = @2;
    task2.taskTitle = @"Some Title";
    task2.taskAdditionalInfo = @"task addd info";
    task2.taskPriority = @1;
    task2.taskDate = [NSDate date];
    
    CoreDataManager *cm = [[CoreDataManager alloc] init];
//    [cm addData:task];
//    [cm addData:task2];
//    [cm deleteData:task];
    
    
    
    TaskObject * fetchedTask = [cm fetchTaskObjectWithID:@2];
    NSLog(@"%@",[fetchedTask description]);
    return YES;
}




- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  
}


@end
