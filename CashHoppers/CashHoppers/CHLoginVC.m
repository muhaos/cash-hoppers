//
//  CHLoginVC.m
//  CashHoppers
//
//  Created by Vova Musiienko on 14.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHLoginVC.h"
#import "CHLoadingVC.h"
#import "CHAPIClient.h"
@interface CHLoginVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;

@end

@implementation CHLoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark  - textField delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self shiftViewUp];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self shiftViewToDefault];
    
}

#pragma mark - shift view up/down methods

-(void)shiftViewUp{
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = -40;
    [UIView animateWithDuration:.2 animations:^{
        self.view.frame = newFrame;
    }];
}

-(void)shiftViewToDefault{
    CGRect newFrame = self.view.frame;
    newFrame.origin.y = 0;
    [UIView animateWithDuration:.2 animations:^{
        self.view.frame = newFrame;
    }];
    
}

#pragma mark - ibactions

- (IBAction)loginTapped:(id)sender {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:_emailField.text /*jekahy343@gmail.com"*/ forKey:@"email"];
    [params setObject:_passwordField.text/*@"12345678"*/ forKey:@"password"];
    [params setObject:CH_API_KEY forKey:@"api_key"];
    
    //Parsing to JSON!
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    //If no error we send the post, voila!
    if (!error){
        [[CHLoadingVC sharedLoadingVC] showInController:self withText:@"Processing..."];
        
        AFHTTPClient *client = [CHAPIClient sharedClient];
        NSString *path = [NSString stringWithFormat:@"api/sessions"];
        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:json];
        [request setHTTPShouldHandleCookies:YES];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSInteger success = [[JSON  objectForKey:@"success"]integerValue];
            NSString* atoken = [JSON objectForKey:@"authentication_token"];
            NSString *message;
            if(success == 1){
                message = @"Login successfull!";
                [self goToTabBar];
                
            }else{
                message = [NSString stringWithFormat:@"Login unsuccessfull: %@",[JSON objectForKey:@"errors"]];
            }
                        
//            NSLog(@"json=%@",JSON);
            [[NSUserDefaults standardUserDefaults] setValue:atoken forKey:@"a_token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"LOGIN" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [av show];
            [[CHLoadingVC sharedLoadingVC] hide];
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSString* errMsg = nil;
            if (JSON != nil) {
                errMsg = [JSON  objectForKey:@"info"];
            } else {
                errMsg = [error localizedDescription];
            }
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"LOGIN" message:[NSString stringWithFormat:@"Login unsuccessful: %@", errMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            [[CHLoadingVC sharedLoadingVC] hide];
        }];
        
        [operation start];
    }

}

-(void)goToTabBar{
    [self performSegueWithIdentifier:@"tabbar" sender:self];
}

-(IBAction)hideKeyboard:(id)sender{
    [_passwordField resignFirstResponder];
    [_emailField resignFirstResponder];
}

- (void)viewDidUnload {
    [self setEmailField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}
@end
