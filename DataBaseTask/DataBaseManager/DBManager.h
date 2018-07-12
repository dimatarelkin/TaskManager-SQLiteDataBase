//
//  DBManager.h
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/9/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic, assign) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

- (instancetype)initWithDataBaseFileName:(NSString*)dbFilename;

-(NSArray*)loadDataFromDB:(NSString*)query;
-(void)executeQuery:(NSString*)query;

@end
