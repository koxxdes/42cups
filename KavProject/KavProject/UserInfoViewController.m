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
#import "InputValidator.h"

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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) SQLHelper *helper;
@property (strong, nonatomic) FacebookModel *networkModel;
@property (strong, nonatomic) InputValidator *validator;

@property (strong, nonatomic) UIGestureRecognizer *recognizer;
@property (weak, nonatomic) UITextField *currentTextView;

@end

@implementation UserInfoViewController{
    float textFieldWidth;
    float textViewWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.helper = [[SQLHelper alloc] init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.networkModel = delegate.networkModel;
    self.networkModel.userDelegate = self;
    
    if (self.networkModel.wasLoginWithExistingSession) {
        [self updateUI:[self.helper getUserInfo]];
    }else{
        [self.networkModel requestUserInfo];
    }
    
    self.validator = [[InputValidator alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:self.recognizer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [self.view removeGestureRecognizer:self.recognizer];
}

-(void)dismissKeyboard:(UITapGestureRecognizer *)recognizer
{
    [self.currentTextView resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, self.interfaceOrientation == UIInterfaceOrientationPortrait ?  kbSize.height : kbSize.width, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    //CGRect aRect = self.view.bounds;
    //aRect.size.height -= kbSize.height;
    //if (!CGRectContainsPoint(aRect, self.currentTextView.frame.origin) ) {
        [self.scrollView scrollRectToVisible:CGRectMake(self.currentTextView.frame.origin.x, self.currentTextView.frame.origin.y, 10, 10) animated:YES];
    //}
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (![self.validator isValidName:self.nameTextField.text]) {
                [delegate showMessage:@"Name error" withTitle:@"Please enter correct name"];
                return;
            }
            if (![self.validator isValidSurname:self.surnameTextField.text]) {
                [delegate showMessage:@"Surname error" withTitle:@"Please enter correct surname"];
                return;
            }
            if (![self.validator isValidBirthday:self.dateOfBirthTextield.text]) {
                [delegate showMessage:@"Birthday error" withTitle:@"Please enter correct date"];
                return;
            }
            if (![self.validator isValidEmail:self.emailTextField.text]) {
                [delegate showMessage:@"Email error" withTitle:@"Please enter correct email"];
                return;
            }
    [self updateUserInfoFromInput];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextView = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)updateUserInfoFromInput
{
    UserInfo *userInfo = [self.helper getUserInfo];
    userInfo.name = self.nameTextField.text;
    userInfo.surname = self.surnameTextField.text;
    userInfo.email = self.emailTextField.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/mm/yyyy"];
    userInfo.dateOfBirth = [formatter dateFromString:self.dateOfBirthTextield.text];
    
    __weak UserInfoViewController *wSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [wSelf.helper updateUserInfo:userInfo];
    });
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
