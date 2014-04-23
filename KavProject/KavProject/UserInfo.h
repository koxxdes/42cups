//
//  UserInfo.h
//  KavProject
//
//  Created by Victor on 4/19/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *surname;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (strong, nonatomic) NSData *picture;

@end
