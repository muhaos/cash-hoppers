//
//  CHRegisterVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/20/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHRegisterVC.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "CHLoadingVC.h"
#import "CHAPIClient.h"
#import "CHAgreeToTermsVC.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface CHRegisterVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    CGFloat animatedDistance;
}

@property (assign, nonatomic) BOOL oldNavBarStatus;

@end

@implementation CHRegisterVC

@synthesize emailView, zipView, requiredLabel, zipTextField, userNameTextField, passwordTextField, photoImageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [emailView setBackgroundColor:[UIColor clearColor]];
    [zipView setBackgroundColor:[UIColor clearColor]];
    [requiredLabel setTextColor:[UIColor redColor]];
    [self setupTriangleBackButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registrationUser)
                                                 name:@"AgreeToTerms"
                                               object:nil];
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setTitle:@""];
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
    [self setPhotoImageView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}


- (IBAction)registerTapped:(id)sender
{
    [[CHAgreeToTermsVC sharedAgreeToTermsVC] showInController:self];
}


-(void)registrationUser
{
    NSString *image64string = [CHAPIClient base64stringFromImage:photoImageView.image];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:_emailTextField.text/*@"jekahy343@gmail.com"*/ forKey:@"email"];
    [params setObject:passwordTextField.text/*@"123456789"*/ forKey:@"password"];
    [params setObject:passwordTextField.text/*@"123456789"*/ forKey:@"password_confirmation"];
    [params setObject:CH_API_KEY forKey:@"api_key"];
    [params setObject:_firstNameTextField.text /*@"123456789"*/ forKey:@"first_name"];
    [params setObject:_lastNameTextField.text forKey:@"last_name"];
    [params setObject:userNameTextField.text forKey:@"user_name"];
    [params setObject:@"image/jpeg" forKey:@"avatar_content_type"];
    [params setObject:@"myavatar.jpg" forKey:@"avatar_original_filename"];
    
    [params setObject:image64string forKey:@"base64avatar"];
    [params setObject:@"myavatar.jpg" forKey:@"avatar_original_filename"];
    [params setObject:zipTextField.text/*@"123456789"*/ forKey:@"zip"];
    
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    if (!error){
        [[CHLoadingVC sharedLoadingVC] showInController:self withText:@"Processing..."];
        
        AFHTTPClient *client = [CHAPIClient sharedClient];
        NSString *path = [NSString stringWithFormat:@"api/sign_up"];
        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:json];
        [request setHTTPShouldHandleCookies:YES];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSInteger success = [[JSON  objectForKey:@"success"]integerValue];
            NSString *message;
            if(success == 1){
                message = [NSString stringWithFormat:@"Registration successful: %@",[JSON objectForKey:@"message"]];
                message = @"Registration successful: Check your email and confirm registration.";
                [self backButtonTapped];
                
            }else{
                message = [NSString stringWithFormat:@"Registration unsuccessful: %@",[JSON objectForKey:@"errors"]];
            }
            
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"REGISTRATION" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [av show];
            [[CHLoadingVC sharedLoadingVC] hide];
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            
            NSString* errMsg = nil;
            if (JSON != nil) {
                errMsg = [JSON  objectForKey:@"info"];
            } else {
                errMsg = [error localizedDescription];
            }
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"REGISTRATION" message:[NSString stringWithFormat:@"Registration unsuccessful. Try again later."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            [[CHLoadingVC sharedLoadingVC] hide];
        }];
        
        [operation start];
    }
}


- (IBAction)addPhotoTapped:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    [self.zipTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
	photoImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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


@end
