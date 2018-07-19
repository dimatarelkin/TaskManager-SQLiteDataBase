//
//  ManagerLayerForCoreDataAndSQLite.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/16/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "ManagerLayerForCoreDataAndSQLite.h"
#import "TaskObject.h"
#import "DBManager.h"
#import "CoreDataManager.h"

@interface ManagerLayerForCoreDataAndSQLite ()

@property (strong, nonatomic) DBManager *sqliteManager;
@property (strong, nonatomic) CoreDataManager *coreDataManager;

@end




@implementation ManagerLayerForCoreDataAndSQLite


- (instancetype)initWithDataBaseType:(DataBaseType)dbType
{
    self = [super init];
    if (self) {
        [self dataBaseType:dbType];
        self.type = dbType;
        
    }
    return self;
}



-(void)dataBaseType:(DataBaseType)dbType {
    [self createSQLiteManager];
    [self createCoreDataManager];
}


-(void)createSQLiteManager {
    _sqliteManager  = [[DBManager alloc] initWithDataBaseFileName:@"tasksDB.db"];
}

-(void)createCoreDataManager {
     _coreDataManager = [[CoreDataManager alloc] init];
}




#pragma mark - Operations

-(void)addData:(TaskObject*)data  {
    [_sqliteManager addData:data];
    [_coreDataManager addData:data];
}

- (void)updateData:(TaskObject *)data {
    [_sqliteManager updateData:data];
    [_coreDataManager updateData:data];
}

-(void)deleteData:(TaskObject*)data {
    [_sqliteManager deleteData:data];
    [_coreDataManager deleteData:data];
}


-(TaskObject*)fetchTaskObjectWithID:(NSNumber*)iD {
    TaskObject *task = [[TaskObject alloc] init];
    
    if (self.type == SQLiteType) {
        task = [_sqliteManager fetchTaskObjectWithID:iD];
    } else {
        task = [_coreDataManager fetchTaskObjectWithID:iD];
    }
    return task;
}


- (void)deleteAllData {
    [_sqliteManager deleteAllData];
    [_coreDataManager deleteAllData];
}



- (NSArray *)fetchAllDataTaskObjects {
    NSArray* allTasks;
    
    if (self.type == SQLiteType) {
        allTasks = [_sqliteManager fetchAllDataTaskObjects];
    } else {
        allTasks = [_coreDataManager fetchAllDataTaskObjects];
    }
    return allTasks;
}


@end
