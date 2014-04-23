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
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"kavyarnya.sqlite3"];
        if (![fileManager fileExistsAtPath:writableDBPath]){
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"kavyarnya.sqlite3"];
        [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        }
        
        if (!error && sqlite3_open([writableDBPath UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"failed to open db");
            return nil;
        }
    }
    return self;
}

-(void)updateUserInfo:(UserInfo *)info
{
    NSString *query = @"UPDATE user SET name = ?, surname = ?, email = ?, bio = ?, birth = ?, image = ? WHERE id = 0";
    sqlite3_stmt *statement;
    if (sqlite3_prepare(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [info.name UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [info.surname UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [info.email UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 4, [info.bio UTF8String], -1, NULL);
        sqlite3_bind_int(statement, 5, [info.dateOfBirth timeIntervalSince1970]);
        sqlite3_bind_blob(statement, 6, [info.picture bytes], [info.picture length], NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"update error %s", sqlite3_errmsg(_database));
        }
        sqlite3_finalize(statement);
    }else
        NSLog(@"Error %s while preparing statement", sqlite3_errmsg(_database));
}

-(UserInfo *)getUserInfo
{
    UserInfo *info = [[UserInfo alloc] init];
    
    NSString *query = @"SELECT id, name, surname, email, bio, birth, image FROM user AS u WHERE u.id = 0";
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
            info.name = name != NULL ? [NSString stringWithUTF8String:name] : @"";
            info.surname = surname != NULL ? [NSString stringWithUTF8String:surname] : @"";
            info.email = email != NULL ? [NSString stringWithUTF8String:email] : @"";
            info.bio = bio != NULL ? [NSString stringWithUTF8String:bio] : @"";
            info.dateOfBirth = [NSDate dateWithTimeIntervalSince1970:date];
            info.picture = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 6) length:sqlite3_column_bytes(statement, 6)];
            
        }
        sqlite3_finalize(statement);
    }
    return info;
}

@end
