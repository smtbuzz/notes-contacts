//
//  DatabaseSqlite.h
//  SecretFolder
//
//  Created by puneet on 25/07/13.
//  Copyright (c) 2013 Smartbuzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseSqlite : NSObject
{
    sqlite3 *dataBaseObj;
    
    NSString *databasePath ;
}
+(DatabaseSqlite*)getSharedInstance;
-(BOOL)createDB;
- (BOOL) saveData:(NSString*)strFullName   withReferId:(NSString*)ReferID
      withMessage:(NSString*)strMessage;
- (NSMutableArray *) readDataFromDataBase;
-(void)updateContactNote:(NSString *)dbContantID withUpdateMessage:(NSString *)message;

-(void)deleteDataFromDB:(NSString *)LoginId;
@end
