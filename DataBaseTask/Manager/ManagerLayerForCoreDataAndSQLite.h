//
//  ManagerLayerForCoreDataAndSQLite.h
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/16/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskObject.h"


typedef enum {
    SQLiteType,
    CoreDataType,
} DataBaseType;


@protocol ManagerDataBaseProtocol <NSObject>

-(void)addData:(TaskObject*)data;
-(void)updateData:(TaskObject*)data;
-(void)deleteData:(TaskObject*)data;
-(TaskObject*)fetchTaskObjectWithID:(NSNumber*)iD;
-(NSArray*)fetchAllDataTaskObjects;
-(void)deleteAllData;

@end



@interface ManagerLayerForCoreDataAndSQLite : NSObject <ManagerDataBaseProtocol>

@property (assign, nonatomic) DataBaseType type;

-(instancetype)initWithDataBaseType:(DataBaseType)dbType;

@end




