//
//  FacebookModel.m
//  KavProject
//
//  Created by Victor on 4/23/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "FacebookModel.h"

@implementation FacebookModel

-(void)loginWithExistingSession
{
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email", @"user_birthday", @"user_photos"] allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            self.wasLoginWithExistingSession = YES;
            [self sessionStateChanged:session state:status error:error];
        }];
    }

}

-(void)loginWithNewSession
{
    if ([FBSession activeSession].state == FBSessionStateOpen || [FBSession activeSession].state == FBSessionStateOpenTokenExtended) {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }else{
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email", @"user_birthday", @"user_photos"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            self.wasLoginWithExistingSession = NO;
            [self sessionStateChanged:session state:status error:error];
        }];
    }
}

-(void)requestUserInfo
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            [self.userDelegate updateUserInfo:result];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
}

-(BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self.delegate userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self.delegate userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self.delegate showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self.delegate showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self.delegate showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self.delegate userLoggedOut];
    }
}

-(void)handleDidBecomeActive
{
    [FBAppCall handleDidBecomeActive];
}

-(void)getFriendsWithCompletionHandler:(void(^)(NSArray *friends)) handler;
{
    FBRequest *friendsRequest = [FBRequest requestForMyFriends];
    NSMutableArray *returnVal = [NSMutableArray array];
    [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSArray *friends = nil;
        if (!error) {
            friends = result[@"data"];
            for (NSDictionary<FBGraphUser> *friend in friends) {
                FacebookFriend *fr = [[FacebookFriend alloc] init];
                fr.identifier = friend.id;
                fr.name = friend.name;
                fr.surname = friend.last_name;
                [returnVal addObject:fr];
            }
        }
        handler(returnVal);
    }];
}

-(NSData *)getPictureForFriendId:(NSString *)identifier
{
    return [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",identifier]]];
}

@end
