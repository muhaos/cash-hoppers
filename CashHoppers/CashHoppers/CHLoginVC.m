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
#import "CHAppDelegate.h"
#import "CHUserManager.h"
#import "MFSideMenuContainerViewController.h"
#import "CHHopsManager.h"


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface CHLoginVC ()
{
    CGFloat animatedDistance;
}
@property (assign, nonatomic) BOOL oldNavBarStatus;
@end

@implementation CHLoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - textField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - textView Delegate

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}


#pragma mark - ibactions

- (IBAction)loginTapped:(id)sender {
    
    CHAppDelegate *appDelegate = (CHAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.netStatus == NotReachable) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"No internet connection!"
                                                     message:@""
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    } else {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:_emailField.text /*jekahy343@gmail.com"*/ forKey:@"email"];
    [params setObject:_passwordField.text/*@"12345678"*/ forKey:@"password"];
    [params setObject:CH_API_KEY forKey:@"api_key"];
    
    NSString* apns_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"apns_token"];
    if (apns_token != nil) {
        [params setObject:@"IOS" forKey:@"device"];
        [params setObject:apns_token forKey:@"device_token"];
    }
    
    
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
            
            NSDictionary* data = [JSON  objectForKey:@"data"];
            
            NSInteger success = [[JSON  objectForKey:@"success"]integerValue];
            NSString* atoken = [data objectForKey:@"authentication_token"];
            NSString *message;

            [[NSUserDefaults standardUserDefaults] setValue:atoken forKey:@"a_token"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            if(success == 1){
                message = @"Login successfull!";
                
                [[CHUserManager instance] clearCacheWithName:@"users"];
                [[CHHopsManager instance] clearCacheWithName:@"hops"];
                
                
                [self goToTabBar];
                
            }else{
                NSMutableString *errMsg = [[NSMutableString alloc] initWithFormat:@"%@", [JSON objectForKey:@"errors"]];
                [errMsg deleteCharactersInRange:NSMakeRange(0, 5)];
                [errMsg deleteCharactersInRange:NSMakeRange(errMsg.length-2, 2)];
                
                UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"LOGIN" message:errMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [av show];
            }
                        
            [[CHLoadingVC sharedLoadingVC] hide];
            
            [[CHUserManager instance] updateCurrentUser];

        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSString* errMsg = nil;
            if (JSON != nil) {
                errMsg = [JSON  objectForKey:@"info"];
            } else {
                errMsg = [error localizedDescription];
            }
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"LOGIN" message:[NSString stringWithFormat:@"%@",errMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            [[CHLoadingVC sharedLoadingVC] hide];
        }];
        
        [operation start];
        [DELEGATE.menuContainerVC setMenuState:MFSideMenuStateClosed];

    }}

}

-(void)goToTabBar{
    [self presentViewController:DELEGATE.menuContainerVC animated:YES completion:nil];
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
