//
//  FirstViewController.h
//  KavProject
//
//  Created by Victor on 4/18/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookUserInfoProtocol.h"

@interface UserInfoViewController : UIViewController<FacebookUserInfoProtocol, UITextFieldDelegate>

@end
