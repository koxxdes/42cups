//
//  FriendsTest.m
//  KavProject
//
//  Created by Victor on 4/28/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "Kiwi.h"
#import "FacebookFriend.h"
#import "FacebookModel.h"

SPEC_BEGIN(FriendsTest)

describe(@"Testing friends api", ^{
    it(@"should get friends list", ^{
        FacebookModel *model = [[FacebookModel alloc] init];
        [model loginWithNewSession];
        [model getFriendsWithCompletionHandler:^(NSArray *friends) {
            FacebookFriend *firstFriend = [friends firstObject];
            [[firstFriend shouldNot] beNil];
        }];
    });
});

SPEC_END