//
//  ManagerLayerForCoreDataAndSQLite.h
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/16/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    SQLiteType,
    CoreDataType,
} DataBaseType;


@protocol ManagerDataBaseProtocol <NSObject>
-(void)addData:(NSArray*)data;
-(void)updateData:(NSArray*)data;
-(void)deleteData:(NSArray*)data;
-(NSArray*)fetchAllDataTaskObjects;
@end


@interface ManagerLayerForCoreDataAndSQLite : NSObject

@property (assign, nonatomic) DataBaseType type;
-(instancetype)initWithDataBaseType:(DataBaseType)dbType;

-(void)addData:(NSArray*)data;
-(void)insertData:(NSArray*)data;
-(void)deleteData:(NSArray*)data;
-(NSArray*)fetchDataFromDataBase;

@end




