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
#import "CHAgreeToTermsVC.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

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
    
    
//    [[CHLoadingVC sharedLoadingVC] showInController:self withText:@"Please wait..."];
    
    [[CHUserManager instance] isUserExistsForService:self.provider userID:self.idUser completionHandler:^(NSError* error, BOOL exist){

//        [[CHLoadingVC sharedLoadingVC] hide];
        
        if (exist) {
            NSMutableDictionary* params = [NSMutableDictionary new];
            [params setObject:self.provider forKey:@"provider"];
            [params setObject:self.idUser forKey:@"uid"];
            [self signInWithParams:params];
        } else {
            
        }
        
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registration)
                                                 name:@"AgreeToTerms"
                                               object:nil];
}


- (IBAction)registerButtonTapped:(id)sender
{
    [[CHAgreeToTermsVC sharedAgreeToTermsVC] showInController:self];
}


-(void)registration
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
        if (screenNameUser == nil) {
            userName = emailUser;
        } else {
            userName = screenNameUser;
        }
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
