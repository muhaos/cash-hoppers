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

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface CHRegisterVC ()
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
    [super viewDidUnload];
}


- (IBAction)registerTapped:(id)sender {
    
    NSString *image64string = [CHAPIClient base64stringFromImage:photoImageView.image];
//    NSLog(@"image string=%@",image64string);
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
//    [params setObject:@"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" forKey:@"base64avatar"];
    [params setObject:image64string forKey:@"base64avatar"];
    [params setObject:@"myavatar.jpg" forKey:@"avatar_original_filename"];
    [params setObject:zipTextField.text/*@"123456789"*/ forKey:@"zip"];

    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
//    NSLog(@"json=%@",json);

    if (!error){
        [[CHLoadingVC sharedLoadingVC] showInController:self withText:@"Processing..."];
        
        AFHTTPClient *client = [CHAPIClient sharedClient];
        NSString *path = [NSString stringWithFormat:@"api/sign_up"];
        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:json];
        [request setHTTPShouldHandleCookies:YES];
        NSLog(@"req=%@",request);

        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSInteger success = [[JSON  objectForKey:@"success"]integerValue];
            NSString *message;
            if(success == 1){
                message = [NSString stringWithFormat:@"Registration successful: %@",[JSON objectForKey:@"message"]];
//                message = @"Check your email and confirm registration.";
                [self backButtonTapped];

            }else{
                message = [NSString stringWithFormat:@"Registration unsuccessful: %@",[JSON objectForKey:@"errors"]];
            }

            
            NSLog(@"json=%@",JSON);
            
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"REGISTRATION" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [av show];
            [[CHLoadingVC sharedLoadingVC] hide];
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"json=%@",JSON);

            NSString* errMsg = nil;
            if (JSON != nil) {
                errMsg = [JSON  objectForKey:@"info"];
            } else {
                errMsg = [error localizedDescription];
            }
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"REGISTRATION" message:[NSString stringWithFormat:@"Registration unsuccessful : %@", errMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
	[picker dismissModalViewControllerAnimated:YES];
	photoImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
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
