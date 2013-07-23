//
//  CHProfileUserVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/23/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHProfileUserVC.h"

@interface CHProfileUserVC ()

@end

@implementation CHProfileUserVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.bioTextView setText:@"Owner of Hayes and Taylor Apparel. UI/UX/Graphic Designer. Buckey Fan."];
    [self.emailTextField setText:@"admin@cashhoppers.com"];
    [self.firstNameTextField setText:@"Brian"];
    [self.lastNameTextField setText:@"Kelly"];
    [self.zipTextField setText:@"345342"];
    [self.usernameTextField setText:@"admin"];
    [self.passwordTextField setText:@"qwerty11"];
    [self.twitterTextField setText:@"admin"];
    [self.facebookTextField setText:@"admin"];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    
    if ([textField isEqual:self.lastNameTextField] || [textField isEqual:self.zipTextField])
    {
        frame.origin.y = -70;
        
    } else if ([textField isEqual:self.usernameTextField] || [textField isEqual:self.passwordTextField])
    {
       frame.origin.y = -130;
    }else if ([textField isEqual:self.twitterTextField] || [textField isEqual:self.facebookTextField])
    {
        frame.origin.y = -180;
    }
        [self.view setFrame:frame];
        [UIView commitAnimations];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame; frame.origin.y = +20;
    [self.view setFrame:frame];
    [UIView commitAnimations];
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
    [super viewDidUnload];
}

@end
