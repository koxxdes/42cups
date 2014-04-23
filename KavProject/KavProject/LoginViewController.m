//
//  LoginViewController.m
//  KavProject
//
//  Created by Victor on 4/22/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTapped:(UIButton *)sender {
    if ([FBSession activeSession].state == FBSessionStateOpen || [FBSession activeSession].state == FBSessionStateOpenTokenExtended) {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }else{
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email", @"user_birthday", @"user_photos"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            [delegate sessionStateChanged:session state:status error:error];
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
