//
//  InputValidator.h
//  KavProject
//
//  Created by Victor on 4/25/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputValidator : NSObject

-(BOOL)isValidName:(NSString *)name;
-(BOOL)isValidSurname:(NSString *)surname;
-(BOOL)isValidEmail:(NSString *)email;
-(BOOL)isValidBirthday:(NSString *)birthday;

@end
