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


@property (strong, nonatomic) NSString *addQuery;
@property (strong, nonatomic) NSString *deleteQuery;
@property (strong, nonatomic) NSString *selectQuery;

@end





@implementation ManagerLayerForCoreDataAndSQLite


- (instancetype)initWithDataBaseType:(DataBaseType)dbType
{
    self = [super init];
    if (self) {
        [self dataBaseType:dbType];
        
    }
    return self;
}



-(void)dataBaseType:(DataBaseType)dbType {
    switch (dbType) {
        case SQLiteType:
            [self createSQLiteManager];
            break;
        case CoreDataType:
            [self createCoreDataManager];
            break;
        default:
            break;
    }
}


-(void)createSQLiteManager {
    _sqliteManager  = [[DBManager alloc] initWithDataBaseFileName:@"tasksDB.db"];
    self.type = SQLiteType;
}

-(void)createCoreDataManager {
     _coreDataManager = [[CoreDataManager alloc] init];
    self.type = CoreDataType;
}



-(void)addData:(TaskObject*)data  {
    [_sqliteManager addData:data];
    [_coreDataManager addData:data];
}

-(void)insertData:(NSArray*)data {
    [_sqliteManager updateData:data];
    [_coreDataManager updateData:data];
}

-(void)deleteData:(NSArray*)data {
    [_sqliteManager deleteData:data];
    [_coreDataManager deleteData:data];
}


-(NSArray*)fetchDataFromDataBase{
    NSArray* results;
    
    if (self.type == SQLiteType) {
        results = [NSArray arrayWithArray:[_sqliteManager fetchAllDataTaskObjects]];
    } else {
        results = [NSArray arrayWithArray:[_coreDataManager fetchAllDataTaskObjects]];
    }
    return results;
}


@end
