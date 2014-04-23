//
//  SQLHelper.h
//  KavProject
//
//  Created by Victor on 4/19/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "UserInfo.h"

@interface SQLHelper : NSObject

-(UserInfo *)getUserInfo;
-(void)updateUserInfo:(UserInfo*)info;

@end
