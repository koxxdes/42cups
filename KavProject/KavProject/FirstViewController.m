//
//  FirstViewController.m
//  KavProject
//
//  Created by Victor on 4/18/14.
//  Copyright (c) 2014 Victor. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labeToTextFieldSpacingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bioTextViewWidthConstraint;

@end

@implementation FirstViewController{
    float textFieldWidth;
    float textViewWidth;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
