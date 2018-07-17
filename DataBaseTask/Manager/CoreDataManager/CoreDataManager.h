//
//  CoreDataManager.h
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/16/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagerLayerForCoreDataAndSQLite.h"
#import <CoreData/CoreData.h>
#import "TaskObject.h"



@interface CoreDataManager : NSObject <ManagerDataBaseProtocol>


@property (readonly, strong) NSPersistentContainer *persistentContainer;
- (void)saveContext;

-(void)addDataWith:(TaskObject*)data;


//manager data base protocol methods
-(void)addData:(TaskObject*)data;
-(void)updateData:(NSArray*)data;
-(void)deleteData:(NSArray*)data;
-(NSArray*)fetchAllDataTaskObjects;
-(TaskObject*)fetchTaskObjectWithID:(NSNumber*)iD;
@end
