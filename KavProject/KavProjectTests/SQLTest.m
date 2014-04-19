//
//  SQLTest.m
//  KavProject
//
//  Created by Victor on 4/19/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "Kiwi.h"
#import "SQLHelper.h"

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
        [[info.name shouldNot] beNil];
    });
});

SPEC_END


