//
//  CHResetPasswordVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/20/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHResetPasswordVC.h"
#import "CHAPIClient.h"
#import "CHAppDelegate.h"

@interface CHResetPasswordVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;

@end

@implementation CHResetPasswordVC

@synthesize emailTextField;


- (void)viewDidLoad {
    [super viewDidLoad];
    [emailTextField becomeFirstResponder];
    [self setupTriangleBackButton];
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (IBAction)signInTapped:(id)sender {
    CHAppDelegate *appDelegate = (CHAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.netStatus == NotReachable) {

        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"No internet connection!"
                                                     message:@""
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    } else {
        NSString *path = [NSString stringWithFormat:@"/api/sessions/reset_password.json?api_key=%@&email=%@", CH_API_KEY, emailTextField.text];
        
        NSMutableURLRequest *request = [[CHAPIClient sharedClient] requestWithMethod:@"POST" path:path parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success"
                                                         message:@"Confirmation instructions sended. Please check your email."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];

        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                     message:@"Error"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
            [av show];
        }];
        [operation start];
    }
}


#pragma mark - UITextFieldDelegate methods
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
    [super viewDidUnload];
}


@end
