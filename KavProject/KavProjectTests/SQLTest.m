//
//  SQLTest.m
//  KavProject
//
//  Created by Victor on 4/19/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "Kiwi.h"
#import "SQLHelper.h"
UserInfo * storedInfo;

SPEC_BEGIN(SQLTestConnection)

describe(@"Testing db setup ", ^{
    it(@"should connect fine", ^{
        SQLHelper *helper = [[SQLHelper alloc] init];
        [[helper shouldNot] beNil];
    });
});

SPEC_END

SPEC_BEGIN(SQLTestGetInfo)

describe(@"Testing db api ", ^{
    it(@"should return correct user info", ^{
        SQLHelper *helper = [[SQLHelper alloc] init];
        UserInfo *info = [helper getUserInfo];
        storedInfo = info;
        [[info.name shouldNot] beNil];
        [[info.surname shouldNot] beNil];
        [[info.email shouldNot] beNil];
        [[info.bio shouldNot] beNil];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/mm/yyyy"];
        [[[formatter stringFromDate:info.dateOfBirth] shouldNot] beNil];
    });
});

SPEC_END

SPEC_BEGIN(SQLTestSetInfo)

describe(@"Testing db api ", ^{
    it(@"should save user info", ^{
        UserInfo *info = [[UserInfo alloc] init];
        info.name = @"test";
        info.surname = @"test1";
        info.email = @"test3";
        info.bio = @"test4";
        
        SQLHelper *helper = [[SQLHelper alloc] init];
        [helper updateUserInfo:info];
        info = [helper getUserInfo];
        [[info.name should] equal:@"test"];
        [[info.surname should] equal:@"test1"];
        [[info.email should] equal:@"test3"];
        [[info.bio should] equal:@"test4"];

        [helper updateUserInfo:storedInfo];
    });
});

SPEC_END


