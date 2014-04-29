//
//  FacebookFriend.h
//  KavProject
//
//  Created by Victor on 4/28/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookFriend : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *surname;
@property (strong, nonatomic) UIImage *picture;

@property (nonatomic) NSInteger priority;

@end
