//
//  InputValidator.m
//  KavProject
//
//  Created by Victor on 4/25/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "InputValidator.h"

@implementation InputValidator

-(BOOL)isValidName:(NSString *)name
{
    return [self validateString:name ToRegex:@"^[A-Z][a-z]+$"];
}

-(BOOL)isValidSurname:(NSString *)surname
{
    return [self validateString:surname ToRegex:@"^[A-Z][a-z]+$"];
}

-(BOOL)isValidEmail:(NSString *)email
{
    return [self validateString:email ToRegex:@"^[A-Za-z0-9._-]+@[A-Za-z0-9]+\\.[a-z]{2,6}$"];
}

-(BOOL)isValidBirthday:(NSString *)birthday
{
    return [self validateString:birthday ToRegex:@"^(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)\\d\\d$"];
}

-(BOOL)validateString:(NSString *)string ToRegex:(NSString *)pattern
{
    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"error creating regex %@", [error localizedDescription]);
    }
    NSRange matchRange = [regex rangeOfFirstMatchInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    if (matchRange.location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
