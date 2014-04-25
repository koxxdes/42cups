//
//  ValidationTest.m
//  KavProject
//
//  Created by Victor on 4/25/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "Kiwi.h"
#import "InputValidator.h"


SPEC_BEGIN(NameValidation)

describe(@"Testing name validation", ^{
    it(@"should correctly validate Mark", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidName:@"Mark"]) should] beTrue];
    });
    it(@"should not validate \" Mark\"", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidName:@" Mark"]) should] beFalse];
    });
    it(@"should not validate Mark1", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidName:@"Mark1"]) should] beFalse];
    });
    it(@"should not validate mark", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidName:@"mark"]) should] beFalse];
    });
    it(@"should not validate 1mark", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidName:@"1mark"]) should] beFalse];
    });
    it(@"should not validate Mark Simon", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidName:@"Mark Simon"]) should] beFalse];
    });
    it(@"should not validate MarkSimon", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidName:@"MarkSimon"]) should] beFalse];
    });
    it(@"should not validate Mark@simon", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidName:@"Mark@simon"]) should] beFalse];
    });
});

SPEC_END
