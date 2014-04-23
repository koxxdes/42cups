//
//  FirstViewController.m
//  KavProject
//
//  Created by Victor on 4/18/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SQLHelper.h"
#import "AppDelegate.h"

@interface UserInfoViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labeToTextFieldSpacingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bioTextViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *userPicture;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *surnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@property (strong, nonatomic) SQLHelper *helper;
@end

@implementation UserInfoViewController{
    float textFieldWidth;
    float textViewWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.helper = [[SQLHelper alloc] init];
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            [self updateUserInfo:result];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)updateUserInfo:(NSDictionary *)info
{
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.name = info[@"first_name"];
    userInfo.surname = info[@"last_name"];
    userInfo.email = info[@"email"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm/dd/yyyy"];
    userInfo.dateOfBirth = [formatter dateFromString:info[@"birthday"]];
    
    NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", info[@"username"]];
    __weak UserInfoViewController *wSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
        userInfo.picture = imageData;
        [wSelf.helper updateUserInfo:userInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [wSelf updateUI:userInfo];
        });
    });
}

-(void)updateUI:(UserInfo *)info
{
    self.nameTextField.text = info.name;
    self.surnameTextField.text = info.surname;
    self.emailTextField.text = info.email;
    self.bioTextView.text = info.bio;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/mm/yyyy"];
    self.dateOfBirthTextield.text = [formatter stringFromDate:info.dateOfBirth];
    self.userPicture.image = [UIImage imageWithData:info.picture];
    
}

- (IBAction)logoutButtonTapped:(UIButton *)sender {
    [[FBSession activeSession] closeAndClearTokenInformation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        textFieldWidth = self.textFieldWidthConstraint.constant;
        textViewWidth = self.bioTextViewWidthConstraint.constant;
        
        self.textFieldWidthConstraint.constant = self.view.frame.size.width - self.labelWidthConstraint.constant - self.labeToTextFieldSpacingConstraint.constant - 2*40;
        self.bioTextViewWidthConstraint.constant = self.view.frame.size.width - 2*40;
    }else
    {
        self.textFieldWidthConstraint.constant = textFieldWidth;
        self.bioTextViewWidthConstraint.constant = textViewWidth;
    }
}

@end
