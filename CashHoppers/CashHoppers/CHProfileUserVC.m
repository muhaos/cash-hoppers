//
//  CHProfileUserVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/23/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHProfileUserVC.h"
#import "CHUserManager.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface CHProfileUserVC ()
{
    CGFloat animatedDistance;
}

@end

@implementation CHProfileUserVC
@synthesize scrollView, bioTextView, emailTextField, firstNameTextField, lastNameTextField,zipTextField, usernameTextField, passwordTextField, twitterTextField, facebookTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CHUser* user = [CHUserManager instance].currentUser;
    
    [self.bioTextView setText:user.bio];
    [self.emailTextField setText:user.email];
    [self.firstNameTextField setText:user.first_name];
    [self.lastNameTextField setText:user.last_name];
    [self.zipTextField setText:user.zip];
    [self.usernameTextField setText:user.user_name];
    [self.passwordTextField setText:@"kuku"];
    [self.twitterTextField setText:user.twitter];
    [self.facebookTextField setText:user.facebook];
    [self.googlePlusTextField setText:user.google];
    [self.contactTextField setText:user.contact];
    [self.phoneTextField setText:user.phone];
    
    [self setupTriangleBackButton];
    
    self.scrollView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(320.0f, 700.0f);
}


- (void) backButtonTapped {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)photoButtonTapped:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	self.photoImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
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


- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setBioTextView:nil];
    [self setEmailTextField:nil];
    [self setFirstNameTextField:nil];
    [self setLastNameTextField:nil];
    [self setZipTextField:nil];
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setTwitterTextField:nil];
    [self setFacebookTextField:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

@end
