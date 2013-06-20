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
