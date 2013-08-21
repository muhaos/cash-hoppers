//
//  CHAdditionalSigninFormVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/19/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAdditionalSigninFormVC.h"
#import <QuartzCore/QuartzCore.h>

@interface CHAdditionalSigninFormVC ()
{
    CGFloat animatedDistance;
}

@end

@implementation CHAdditionalSigninFormVC
@synthesize zipTextField, emailTextField, photoImageView, screenNameUser, firstNameUser, lastNameUser, emailUser, idUser, imageUser;


- (void)viewDidLoad
{
    [super viewDidLoad];
    photoImageView.layer.cornerRadius = 3.0f;
    photoImageView.layer.masksToBounds = YES;
    photoImageView.image = imageUser;
    emailTextField.text = emailUser;
    [self setupTriangleBackButton];
}


- (IBAction)registerButtonTapped:(id)sender
{
    
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}


#pragma mark  - textField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setEmailTextField:nil];
    [self setZipTextField:nil];
    [self setPhotoImageView:nil];
    [super viewDidUnload];
}


@end
