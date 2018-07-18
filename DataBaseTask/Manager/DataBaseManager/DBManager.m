//
//  DBManager.m
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/9/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>



//Table
static NSString * const kTableTaskName  = @"Tasks";
static NSString * const kColumnID       = @"taskID";
static NSString * const kColumnTitle    = @"taskTitle";
static NSString * const kColumnPriority = @"taskPriority";
static NSString * const kColumnAddInfo  = @"taskAdditionalInfo";
static NSString * const kColumnDate     = @"date";



@interface DBManager ()
@property (nonatomic, strong) NSString *documentDirectory;
@property (nonatomic, strong) NSString *dataBaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;

-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end


@implementation DBManager

// 1
- (instancetype)initWithDataBaseFileName:(NSString*)dbFilename {
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentDirectory = [paths objectAtIndex:0];
        
        //keep the database filename
        self.dataBaseFilename = dbFilename;
        
        //copy db file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
    }
    
    return self;
}


// 2
- (void)copyDatabaseIntoDocumentsDirectory {
    //checking existance
    NSString *destinationPath = [self.documentDirectory stringByAppendingPathComponent:self.dataBaseFilename];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath]
                               stringByAppendingPathComponent:self.dataBaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        //error
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}




#pragma mark - DataBase methods

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable {
    //create dataBase object
    sqlite3 * sqlite3dataBase;
    NSString * dataBasePath = [self.documentDirectory stringByAppendingPathComponent:self.dataBaseFilename];
    
    //init arr results
    if (self.arrResults != nil) {
       [self.arrResults removeAllObjects];
       self.arrResults = nil;
    }
    self.arrResults = [NSMutableArray array];

    //init columns
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [NSMutableArray array];


//OPEN THE DATABASE
    BOOL openDataBaseResult = sqlite3_open([dataBasePath UTF8String], &sqlite3dataBase);
    //1 - path,2 - pointer to dataBase itself
    
    if (openDataBaseResult == SQLITE_OK) {
        NSLog(@"DB is opened");
        
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        //
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3dataBase, query, -1, &compiledStatement, NULL);
        // 1 - db piointer, 2 - query (from func), 3 - -1 = undefiend, 4 - pointer statement, 5 - Pointer to unused portion of zSql
        
        if (prepareStatementResult == SQLITE_OK) {
            NSLog(@"DB is prepared");
            
            // Check if the query is non-executable JUST FETCH DATA
            if (!queryExecutable) {
                NSLog(@"current query is NOT executable, Loading Data");
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row.
                while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    arrDataRow = [NSMutableArray array];
                    
                    //get the total number of columns
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    //go through all columns
                    for (int i = 0; i < totalColumns; i++) {
                        NSLog(@"load column data");
                        //convert column data to text
                        char * dbAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the current column (field) then add them to the current row array.
                        if (dbAsChars != NULL) {
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbAsChars]];
                        }
                        
                        //keep the current column name
                        if (self.arrColumnNames.count != totalColumns ) {
                            dbAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbAsChars]];
                            NSLog(@"add Column with name -%@ ",[NSString stringWithUTF8String:dbAsChars]);
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
                
            } else {
                NSLog(@"Query is executable!");
                
                //execute the query
                
                if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    //keep the affected rows
                    self.affectedRows = sqlite3_changes(sqlite3dataBase);
                    
                    //keep the last inserted row ID
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3dataBase);
                } else {
                    NSLog(@"DB Error: %s",sqlite3_errmsg(sqlite3dataBase));
                }
            }
        } else {
            //if the db is can't be opened
            NSLog(@"Can't open db, error %s", sqlite3_errmsg(sqlite3dataBase));
        }
        
        //released the compile statement
        sqlite3_finalize(compiledStatement);
    }
    //close the DataBase
    sqlite3_close(sqlite3dataBase);
    
}


#pragma mark - Public DB methods

- (NSArray *)loadDataFromDB:(NSString *)query {
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    //return the loaded results
    NSLog(@"Arr results %@",[self.arrResults componentsJoinedByString:@"-"]);
    return (NSArray *)self.arrResults;
}

- (void)executeQuery:(NSString *)query {
    //run the query
    [self runQuery: [query UTF8String] isQueryExecutable:YES];
}




#pragma mark - Operations

- (void)addData:(TaskObject *)data {
    NSString *query = [NSString stringWithFormat:@"insert into %@ values(null, '%@', '%@', %li, '%f')",
            kTableTaskName,
            data.taskTitle,
            data.taskAdditionalInfo,
            [data.taskPriority integerValue], [data.taskDate timeIntervalSince1970]];
    
    [self executeQuery:query];
    NSLog(@"Add Query");
}


- (void)deleteAllData {
    NSString *deleteAllTasksQeuery = [NSString stringWithFormat:@"delete * from %@",kTableTaskName];
    [self executeQuery:deleteAllTasksQeuery];
    NSLog(@"DeleteAllData Query");
}

- (void)deleteData:(TaskObject *)data {
    NSString *deleteQeuery = [NSString stringWithFormat:@"delete from %@ where %@ = %li", kTableTaskName, kColumnID,(long)[data.iD integerValue]];
    [self executeQuery:deleteQeuery];
    NSLog(@"Delete record Query");
}



- (NSArray *)fetchAllDataTaskObjects {
    NSArray* allTasks;
    NSMutableArray<TaskObject*>* arrayOfTasks = [NSMutableArray array];
    
    NSString* loadDataQuery =  [NSString stringWithFormat:@"select * from %@;",kTableTaskName];
    allTasks = [self loadDataFromDB:loadDataQuery];
    NSLog(@"all tasks %@" , [allTasks componentsJoinedByString:@"-"]);
    
    for (NSArray* fieldsOfTask in allTasks ) {
        TaskObject* task = [[TaskObject alloc] init];
        task.iD                  = [fieldsOfTask objectAtIndex:0];
        task.taskTitle           = [fieldsOfTask objectAtIndex:1];
        task.taskAdditionalInfo  = [fieldsOfTask objectAtIndex:2];
        task.taskPriority        = (NSNumber*)[fieldsOfTask objectAtIndex:3];
        NSNumber* numberWithDate = (NSNumber*)[fieldsOfTask objectAtIndex:4];
        task.taskDate            = [NSDate dateWithTimeIntervalSince1970:[numberWithDate doubleValue]];
        
        [arrayOfTasks addObject:task];
    }
   
    NSLog(@"Fetch All Data Query");
    return arrayOfTasks;
}


- (TaskObject *)fetchTaskObjectWithID:(NSNumber *)iD {
    NSString* query = [NSString stringWithFormat:@"select * from %@ where %@ = %li",
                       kTableTaskName,
                       kColumnID,
                       (long)[iD integerValue]];
    
    NSArray* objectWithFields = [self loadDataFromDB:query];
    
    TaskObject * task = [[TaskObject alloc] init];
    
    task.iD                  = [[objectWithFields objectAtIndex:0] objectAtIndex:0];
    task.taskTitle           = [[objectWithFields objectAtIndex:0] objectAtIndex:1];
    task.taskAdditionalInfo  = [[objectWithFields objectAtIndex:0] objectAtIndex:2];
    task.taskPriority        = [[objectWithFields objectAtIndex:0] objectAtIndex:3];
    NSNumber* numberWithDate = (NSNumber*)[[objectWithFields objectAtIndex:0] objectAtIndex:4];
    task.taskDate            = [NSDate dateWithTimeIntervalSince1970:[numberWithDate doubleValue]];
    
    NSLog(@"Fetch record Query");
    return task;
}


- (void)updateData:(TaskObject *)data {
    //update
    NSString *query = [NSString stringWithFormat:@"update %@ set %@ = '%@', %@ = '%@', %@ = %ld, %@ = '%f' where %@ = %li",
           kTableTaskName,
           kColumnTitle, data.taskTitle,
           kColumnAddInfo, data.taskAdditionalInfo,
           kColumnPriority, [data.taskPriority integerValue],
           kColumnDate, [data.taskDate timeIntervalSince1970],
           kColumnID, (long)[data.iD integerValue]];
    [self executeQuery:query];
    NSLog(@"Update Query");
}

@end
