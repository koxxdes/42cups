//
//  FacebookNetworkProtocol.h
//  KavProject
//
//  Created by Victor on 4/23/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FacebookNetworkProtocol <NSObject>

-(void)userLoggedIn;
-(void)userLoggedOut;
-(void)showMessage:(NSString *)alertText withTitle:(NSString*)alertTitle;

@end
