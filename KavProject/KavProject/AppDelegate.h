//
//  AppDelegate.h
//  KavProject
//
//  Created by Victor on 4/18/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, FacebookNetworkProtocol>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FacebookModel *networkModel;

@property (nonatomic) BOOL isInternetConnected;

@end
