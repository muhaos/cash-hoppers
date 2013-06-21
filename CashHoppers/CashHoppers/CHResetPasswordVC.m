//
//  CHResetPasswordVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/20/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHResetPasswordVC.h"

@interface CHResetPasswordVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;

@end

@implementation CHResetPasswordVC

@synthesize emailTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [emailTextField becomeFirstResponder];
    
    
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
    [super viewDidUnload];
}


- (IBAction)signInTapped:(id)sender {
}


#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

@end
