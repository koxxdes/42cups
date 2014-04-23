//
//  AppDelegate.h
//  KavProject
//
//  Created by Victor on 4/18/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;

@end
