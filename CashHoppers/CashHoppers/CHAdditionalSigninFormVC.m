//
//  CHAdditionalSigninFormVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/19/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAdditionalSigninFormVC.h"
#import <QuartzCore/QuartzCore.h>
#import "CHUserManager.h"
#import "CHHomeScreenViewController.h"
#import "CHAppDelegate.h"
#import "CHLoadingVC.h"


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
    
    
    [[CHLoadingVC sharedLoadingVC] showInController:self withText:@"Please wait..."];
    
    [[CHUserManager instance] isUserExistsForService:self.provider userID:self.idUser completionHandler:^(NSError* error, BOOL exist){

        [[CHLoadingVC sharedLoadingVC] hide];
        
        if (exist) {
            NSMutableDictionary* params = [NSMutableDictionary new];
            [params setObject:self.provider forKey:@"provider"];
            [params setObject:self.idUser forKey:@"uid"];
            [self signInWithParams:params];
        } else {
            
        }
        
    }];
    
}


- (IBAction)registerButtonTapped:(id)sender
{
    if (self.zipTextField.text == nil || [self.zipTextField.text isEqualToString:@""]) {
        [self showAlertWithText:@"Zip is reqired"];
        return;
    }
    
    if (self.emailTextField.text == nil || [self.emailTextField.text isEqualToString:@""]) {
        [self showAlertWithText:@"Email is reqired"];
        return;
    }
    
    NSMutableDictionary* params = [NSMutableDictionary new];
    [params setObject:self.provider forKey:@"provider"];
    [params setObject:self.idUser forKey:@"uid"];
    [params setObject:self.zipTextField.text forKey:@"zip"];
    [params setObject:self.emailTextField.text forKey:@"email"];
    
    NSString* userName = firstNameUser;
    if (firstNameUser == nil) {
        userName = screenNameUser;
    }
    
    [params setObject:userName forKey:@"name"];
    
    [self signInWithParams:params];
}


- (void) signInWithParams:(NSDictionary*) params {
    [[CHLoadingVC sharedLoadingVC] showInController:self withText:@"Please wait..."];
    
    [[CHUserManager instance] signInViaService:params completionHandler:^(NSError* error, NSDictionary* json){
        
        if (error == nil) {
            NSDictionary* data = [json objectForKey:@"data"];
            NSString* atoken = [data objectForKey:@"authentication_token"];
            [[NSUserDefaults standardUserDefaults] setValue:atoken forKey:@"a_token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.view.window.rootViewController = (UIViewController*)DELEGATE.menuContainerVC;
            [[CHUserManager instance] updateCurrentUser];
        } else {
            [self showAlertWithText:[NSString stringWithFormat:@"Can't signin: %@", [error localizedDescription]]];
        }
        
        [[CHLoadingVC sharedLoadingVC] hide];
    }];
}


- (void) showAlertWithText:(NSString*) text {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
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
