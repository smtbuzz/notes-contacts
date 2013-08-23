//
//  DatabaseSqlite.m
//  SecretFolder
//
//  Created by puneet on 25/07/13.
//  Copyright (c) 2013 Smartbuzz. All rights reserved.
//

#import "DatabaseSqlite.h"
#import "Constants.h"
@implementation DatabaseSqlite
DatabaseSqlite *sharedInstance;




+(DatabaseSqlite*)getSharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB
{
      
    // Build the path to the database file
     databasePath = [KAppDelegate.strDocumentDirectoryPath stringByAppendingPathComponent: @"NoteContacts.sqlite"];
    BOOL isSuccess ;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    isSuccess=[filemgr fileExistsAtPath: databasePath];
    if(isSuccess)
        return YES;
    else
    {
        NSString *filePath=[[NSBundle mainBundle] pathForResource:@"NoteContacts" ofType:@"sqlite"];
        [filemgr copyItemAtPath:filePath toPath:databasePath error:nil];
        [KAppDelegate addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:databasePath]];

        return YES;
    }
    
}

- (BOOL) saveData:(NSString*)strFullName   withReferId:(NSString*)ReferID
       withMessage:(NSString*)strMessage
{
    if (sqlite3_open([databasePath UTF8String], &dataBaseObj) == SQLITE_OK)
    {
        
        NSLog( @"insert into NotesOnContact (FullName,ReferID, Message ) values ('%@','%@','%@')",strFullName,ReferID,strMessage);
        NSString *insertSQL = [NSString stringWithFormat:@"insert into NotesOnContact (FullName,ReferID, Message ) values ('%@','%@','%@')",strFullName,ReferID,strMessage];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_stmt *statement;
        sqlite3_prepare_v2(dataBaseObj, insert_stmt,-1, &statement, NULL);
         if (sqlite3_step(statement) == SQLITE_DONE)
          {
              sqlite3_finalize(statement);
              sqlite3_close(dataBaseObj);
              
              return YES;
            }
            else
            {
                 NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(dataBaseObj) );
                     return NO;
            }
    }
    return NO;
}

- (NSMutableArray*) readDataFromDataBase
 {
       const char *dbpath = [databasePath UTF8String];
       if (sqlite3_open(dbpath, &dataBaseObj) == SQLITE_OK)
       {
          NSString *querySQL = [NSString stringWithFormat:@"select * from NotesOnContact"];
          const char *query_stmt = [querySQL UTF8String];
           sqlite3_stmt *statement;
          NSMutableArray *resultArray = [[NSMutableArray alloc]init];
          if (sqlite3_prepare_v2(dataBaseObj,  query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        NSInteger serialId=sqlite3_column_int(statement, 0);
                        NSString *strFullname = [[NSString alloc] initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 1)];
                        NSString *ReferID = [[NSString alloc] initWithUTF8String:
                                                (const char *) sqlite3_column_text(statement, 2)];
                        NSString *StrMessage = [[NSString alloc]initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 3)];
                      
                        
                        NSDictionary *objDataDic=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",serialId],strFullname,ReferID,StrMessage, nil] forKeys:[NSArray arrayWithObjects:@"SerialId",@"FullName",@"ReferID",@"Message", nil]  ];
                        
                        [resultArray addObject:objDataDic];
                    }
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBaseObj);
                    return resultArray;
                }
                else
                {
                        NSLog(@"Not found");
                        return nil;
                }
                }
     return nil;
 }

#pragma mark  Update Database
-(void)updateContactNote:(NSString *)dbContantID withUpdateMessage:(NSString *)message
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBaseObj) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE NotesOnContact  SET Message='%@' WHERE ID=%@",message,dbContantID];
        NSLog(@"%@",querySQL);
        sqlite3_stmt *statement;
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(dataBaseObj, query_stmt,-1, &statement, NULL);
        sqlite3_step(statement);
        
        sqlite3_finalize(statement);
    }
    NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(dataBaseObj) );
    sqlite3_close(dataBaseObj);
}


#pragma mark  Delete Data From DataBase
-(void)deleteDataFromDB:(NSString *)LoginId
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBaseObj) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"delete from LoginHistory where id=%@",LoginId];
        NSLog(@"%@",querySQL);
        sqlite3_stmt *statement;
        const char *query_stmt = [querySQL UTF8String];
        sqlite3_prepare_v2(dataBaseObj, query_stmt,-1, &statement, NULL);
        sqlite3_step(statement);
    
        sqlite3_finalize(statement);
    }
   NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(dataBaseObj) );
    sqlite3_close(dataBaseObj);
}

@end
