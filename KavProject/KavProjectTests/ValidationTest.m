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

SPEC_BEGIN(SurnameValidation)

describe(@"Testing surname validation", ^{
    it(@"should correctly validate Mark", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidSurname:@"Mark"]) should] beTrue];
    });
    it(@"should correctly validate Mark", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidSurname:@"Mark"]) should] beTrue];
    });
    it(@"should not validate \" Mark\"", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidSurname:@" Mark"]) should] beFalse];
    });
    it(@"should not validate Mark1", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidSurname:@"Mark1"]) should] beFalse];
    });
    it(@"should not validate mark", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidSurname:@"mark"]) should] beFalse];
    });
    it(@"should not validate 1mark", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidSurname:@"1mark"]) should] beFalse];
    });
    it(@"should not validate Mark Simon", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidSurname:@"Mark Simon"]) should] beFalse];
    });
    it(@"should not validate MarkSimon", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidSurname:@"MarkSimon"]) should] beFalse];
    });
    it(@"should not validate Mark@simon", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidSurname:@"Mark@simon"]) should] beFalse];
    });
});

SPEC_END

SPEC_BEGIN(EmailValidation)

describe(@"Testing email validation", ^{
    it(@"should correctly validate Mark@mark.com", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidEmail:@"Mark@mark.com"]) should] beTrue];
    });
    it(@"should correctly validate mark@mark.com", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidEmail:@"mark@mark.com"]) should] beTrue];
    });
    it(@"should correctly validate mark123@mark3.com", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidEmail:@"mark123@mark3.com"]) should] beTrue];
    });
    it(@"should not validate mark%@mark3.com", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidEmail:@"mark%@mark3.com"]) should] beFalse];
    });
    it(@"should not validate mark@mark3.c1m", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidEmail:@"mark@mark3.c1m"]) should] beFalse];
    });
    
});

SPEC_END

SPEC_BEGIN(BirthdayValidation)

describe(@"Testing birthday validation", ^{
    it(@"should correctly validate 23-03-1991", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidBirthday:@"23-03-1991"]) should] beFalse];
    });
    it(@"should correctly validate 23/03/1991", ^{
        InputValidator *validator = [[InputValidator alloc] init];
        [[theValue([validator isValidBirthday:@"23/03/1991"]) should] beTrue];
    });
});
it(@"should not validate 23/13/1991", ^{
    InputValidator *validator = [[InputValidator alloc] init];
    [[theValue([validator isValidBirthday:@"23/13/1991"]) should] beFalse];
});
SPEC_END
