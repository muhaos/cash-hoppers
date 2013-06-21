//
//  CHRegisterVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/20/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHRegisterVC.h"

@interface CHRegisterVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;


@end

@implementation CHRegisterVC

@synthesize emailView, zipView, requiredLabel, zipTextField, userNameTextField, passwordTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [emailView setBackgroundColor:[UIColor clearColor]];
    [zipView setBackgroundColor:[UIColor clearColor]];
    [requiredLabel setTextColor:[UIColor redColor]];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"button_nav_back"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.oldNavBarStatus = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:self.oldNavBarStatus animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setEmailTextField:nil];
    [self setFirstNameTextField:nil];
    [self setLastNameTextField:nil];
    [self setZipTextField:nil];
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setEmailView:nil];
    [self setZipView:nil];
    [super viewDidUnload];
}


- (IBAction)registerTapped:(id)sender {
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:zipTextField] || [textField isEqual:passwordTextField] || [textField isEqual:userNameTextField])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35f];
        CGRect frame = self.view.frame; frame.origin.y = -70;
        [self.view setFrame:frame];
        [UIView commitAnimations];
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame; frame.origin.y = 0;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

@end
