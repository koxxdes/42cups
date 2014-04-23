//
//  FacebookModel.h
//  KavProject
//
//  Created by Victor on 4/23/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookNetworkProtocol.h"
#import "FacebookUserInfoProtocol.h"

@interface FacebookModel : NSObject

@property (nonatomic) BOOL wasLoginWithExistingSession;

@property id<FacebookNetworkProtocol> delegate;
@property id<FacebookUserInfoProtocol> userDelegate;

-(void)loginWithExistingSession;
-(void)loginWithNewSession;

-(void)requestUserInfo;

-(BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication;
-(void)handleDidBecomeActive;

@end
