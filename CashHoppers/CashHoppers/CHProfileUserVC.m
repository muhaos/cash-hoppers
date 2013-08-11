//
//  CHProfileUserVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/23/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHProfileUserVC.h"
#import "CHUserManager.h"
#import "CHLoadingVC.h"
#import "CHNotificationsCell.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface CHProfileUserVC ()
{
    CGFloat animatedDistance;
}

@property (nonatomic, retain) UIImage* changedAvatarImage;
@property (assign, nonatomic) BOOL profileButtonActive;

@end

@implementation CHProfileUserVC
@synthesize scrollView, bioTextView, emailTextField, firstNameTextField, lastNameTextField,zipTextField, usernameTextField, twitterTextField, facebookTextField, profileButton, notificationsButton, notificationsTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
        
    CHUser* user = [CHUserManager instance].currentUser;
    
    [self.bioTextView setText:user.bio];
    [self.emailTextField setText:user.email];
    [self.firstNameTextField setText:user.first_name];
    [self.lastNameTextField setText:user.last_name];
    //[self.zipTextField setText:user.zip];
    [self.usernameTextField setText:user.user_name];
    [self.twitterTextField setText:user.twitter];
    [self.facebookTextField setText:user.facebook];
    [self.googlePlusTextField setText:user.google];
    [self.contactTextField setText:user.contact];
    //[self.phoneTextField setText:user.phone];
    
    [self.photoImageView setImageWithURL:[user avatarURL] placeholderImage:[UIImage imageNamed:@"image_avatar.png"]];
    
    [self setupTriangleBackButton];
    
    self.profileButtonActive = YES;
    [self activeButton:YES];
    
    self.scrollView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(320.0f, 750.0f);
}


- (void) backButtonTapped {
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction) saveTapped {
    
    CHUser* user = [[CHUser alloc] init];
    user.first_name = self.firstNameTextField.text;
    user.last_name = self.lastNameTextField.text;
    user.contact = self.contactTextField.text;
    user.phone = self.phoneTextField.text;
    user.bio = self.bioTextView.text;
    user.twitter = self.twitterTextField.text;
    user.facebook = self.facebookTextField.text;
    user.google = self.googlePlusTextField.text;
    
    NSString* newPassword = nil;
    if (![self.changePasswordTextField.text isEqualToString:@""]) {
        if ([self.changePasswordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
            newPassword = self.changePasswordTextField.text;
        } else {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Passwords are different." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
            return;
        }
    }
    
    [[CHLoadingVC sharedLoadingVC] showInController:self.view.window.rootViewController withText:@"Saving profile..."];
    
    [[CHUserManager instance] updateUserProfileWithUser:user newPassword:newPassword newAvatar:self.changedAvatarImage completionHandler:^(NSError* error) {
        if (error != nil) {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Can't save profile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
        } else {
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"PROFILE" message:@"Profile updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [av show];
        }
        
        [[CHLoadingVC sharedLoadingVC] hide];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)profileButtonTapped:(id)sender
{
    self.profileButtonActive = YES;
    [self activeButton:self.profileButtonActive];
}


- (IBAction)notificationsButtonTapped:(id)sender
{
    self.profileButtonActive = NO;
    [self activeButton:self.profileButtonActive];
}


- (IBAction)photoButtonTapped:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];

}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController.navigationItem setTitle:@""];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	self.photoImageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.changedAvatarImage = self.photoImageView.image;
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


-(void)activeButton:(BOOL)profilesButton {
    if (profilesButton == YES) {
        [profileButton setImage:[UIImage imageNamed:@"button_profile_act"] forState:UIControlStateNormal];
        [notificationsButton setImage:[UIImage imageNamed:@"button_notific_n"] forState:UIControlStateNormal];
        [notificationsTableView removeFromSuperview];
        scrollView.hidden = NO;
    } else {
        [profileButton setImage:[UIImage imageNamed:@"button_profile_n"] forState:UIControlStateNormal];
        [notificationsButton setImage:[UIImage imageNamed:@"button_notific_act"] forState:UIControlStateNormal];
        scrollView.hidden = YES;
        [self.view addSubview:notificationsTableView];
        notificationsTableView.frame = CGRectMake(0, profileButton.frame.origin.y+60, 320, 220);
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *menuCellIdentifier = @"notifications_cell";
    
    if (indexPath.section == 0) {
        CHNotificationsCell *cell = (CHNotificationsCell*) [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
        switch (indexPath.row) {
            case 0:
                cell.nameNotificationTextView.text = @"Alert me when I receive a message";
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
                break;
            case 1:
                cell.nameNotificationTextView.text = @"Alert me about new HOPs";
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
                break;
            case 2:
                cell.nameNotificationTextView.text = @"Alert me when sameone comments or likes my picks";
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
                break;
            case 3:
                cell.nameNotificationTextView.text = @"Alert me when I have a Friend Request";
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
                break;
            case 4:{
                cell.nameNotificationTextView.text = @"Alert me when a HOP is about to end if I have not completed it";
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
                break;
            }
            default:
                break;
        }
        return cell;
    } else {
        return nil;
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    CHNotificationsCell *cell = (CHNotificationsCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.indicatorImageView.image == [UIImage imageNamed:@"icon_indicator_on.png"]) {
        cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
    }else {
        cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setBioTextView:nil];
    [self setEmailTextField:nil];
    [self setFirstNameTextField:nil];
    [self setLastNameTextField:nil];
    [self setZipTextField:nil];
    [self setUsernameTextField:nil];
    [self setTwitterTextField:nil];
    [self setFacebookTextField:nil];
    [self setScrollView:nil];
    [self setProfileButton:nil];
    [self setNotificationsButton:nil];
    [self setNotificationsTableView:nil];
    [super viewDidUnload];
}

@end
