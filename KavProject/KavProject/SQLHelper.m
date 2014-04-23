//
//  SQLHelper.m
//  KavProject
//
//  Created by Victor on 4/19/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "SQLHelper.h"

@implementation SQLHelper{
    sqlite3 *_database;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"kavyarnya" ofType:@"sqlite3"];
        if (sqlite3_open([databasePath UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"failed to open db");
            return nil;
        }
    }
    return self;
}

-(void)updateUserInfo:(UserInfo *)info
{
    NSString *query = @"UPDATE user AS u SET name = ?, surname = ?, email = ?, bio = ?, birth = ? WHERE u.id = 0";
    sqlite3_stmt *statement;
    if (sqlite3_prepare(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 0, [info.name UTF8String], -1, nil);
        sqlite3_bind_text(statement, 1, [info.surname UTF8String], -1, nil);
        sqlite3_bind_text(statement, 2, [info.email UTF8String], -1, nil);
        sqlite3_bind_text(statement, 3, [info.bio UTF8String], -1, nil);
        sqlite3_bind_int(statement, 4, [info.dateOfBirth timeIntervalSince1970]);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"update error");
        }
        sqlite3_finalize(statement);
    }
}

-(UserInfo *)getUserInfo
{
    UserInfo *info = [[UserInfo alloc] init];
    
    NSString *query = @"SELECT id, name, surname, email, bio, birth FROM user AS u WHERE u.id = 0";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int identifier = sqlite3_column_int(statement, 0);
            char *name = (char *) sqlite3_column_text(statement, 1);
            char *surname = (char *) sqlite3_column_text(statement, 2);
            char *email = (char *) sqlite3_column_text(statement, 3);
            char *bio = (char *) sqlite3_column_text(statement, 4);
            double date = sqlite3_column_double(statement, 5);
            
            info.identifier = @(identifier);
            info.name = [NSString stringWithUTF8String:name];
            info.surname = [NSString stringWithUTF8String:surname];
            info.email = [NSString stringWithUTF8String:email];
            info.bio = [NSString stringWithUTF8String:bio];
            info.dateOfBirth = [NSDate dateWithTimeIntervalSince1970:date];
            
        }
        sqlite3_finalize(statement);
    }
    return info;
}

@end
