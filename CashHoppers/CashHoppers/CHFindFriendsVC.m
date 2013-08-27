//
//  CHFindFriendsVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFindFriendsVC.h"
#import "CHAddFriendsSocialNetworksVC.h"
#import "CHAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CHStartVC.h"
#import "FHSTwitterEngine.h"
#import "CHFindFriendsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CHAddFriendVC.h"
#import "CHUserManager.h"

@interface CHFindFriendsVC ()
{
    CGRect screenRect ; 
    CGFloat screenHeight;
}

@end

@implementation CHFindFriendsVC
@synthesize headerText, findFriendsSearchTableView, searchTextField, cancelSearchButton, contentView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    [self setupTriangleBackButton];
    [self customTableView];
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"mW5vfqMKEx1HGME7OeGCg" andSecret:@"RjiYj98WZSjKBbHn9r3hGYvMfptYPp5pQCP8h4gNH5A"];

    findFriendsSearchTableView.hidden = YES;
    cancelSearchButton.hidden = YES;
    cancelSearchButton.layer.cornerRadius = 2.0f;
}


-(void)customTableView
{
    findFriendsSearchTableView.layer.borderColor = [UIColor colorWithRed:204/256.0f green:204/256.0f blue:204/256.0f alpha:0.6f].CGColor;
    findFriendsSearchTableView.layer.borderWidth = 1.0f;
    findFriendsSearchTableView.frame = CGRectMake(20, searchTextField.frame.origin.y+35, 280, screenHeight - 250);
    findFriendsSearchTableView.layer.cornerRadius = 3.0f;
}


- (void) backButtonTapped {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setSearchTextField:nil];
    [self setCancelSearchButton:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    CGRect frame = contentView.frame; frame.origin.y = -55;
    findFriendsSearchTableView.frame = CGRectMake(20, searchTextField.frame.origin.y+35, 280, screenHeight - 330);
    [contentView setFrame:frame];
    [UIView commitAnimations];

    findFriendsSearchTableView.hidden = NO;
    cancelSearchButton.hidden = NO;
    [contentView addSubview:findFriendsSearchTableView];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    CGRect frame = contentView.frame; frame.origin.y = 0;
    findFriendsSearchTableView.frame = CGRectMake(20, searchTextField.frame.origin.y+35, 280, screenHeight- 180);
    [contentView setFrame:frame];
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


- (IBAction) searchFieldChanged:(id)sender {
    [[CHUserManager instance] searchUsersWithQuery:self.searchTextField.text andCompletionHandler:^(NSArray *users) {
        self.searchResultUsers = users;
        [findFriendsSearchTableView reloadData];
    }];
}


- (IBAction)twitterFriendsTapped:(id)sender {
    if ([[FHSTwitterEngine sharedEngine]isAuthorized]) {
        headerText = @"TWITTER FRIENDS";
        [self performSegueWithIdentifier:@"friends" sender:self];
    } else {
        [[FHSTwitterEngine sharedEngine]showOAuthLoginControllerFromViewController:self withCompletion:^(BOOL success) {
            NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        }];
    }
}


- (IBAction)facebookFriendsTapped:(id)sender {
    CHAppDelegate *appDelegate = (CHAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (FBSession.activeSession.isOpen) {
        [appDelegate sendRequest];
    } else {
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}


- (IBAction)googleFriendsTapped:(id)sender {
    headerText = @"GOOGLE PLUS FRIENDS";
    [self performSegueWithIdentifier:@"friends" sender:self];
}


- (IBAction)sendEmailTapped:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        NSArray *emailAddresses = [[NSArray alloc] initWithObjects:nil];
        NSString *sendSubject = [[NSString alloc] initWithFormat:@" "];
        NSString *sendMessage = [[NSString alloc] initWithFormat:@"This is cashhoppers"];
        
        [mailComposer setToRecipients:emailAddresses];
        [mailComposer setSubject:sendSubject];
        [mailComposer setMessageBody:sendMessage isHTML:NO];
        [self presentModalViewController:mailComposer animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}


- (IBAction)cancelSearchButtonTapped:(id)sender {
    cancelSearchButton.hidden = YES;
    findFriendsSearchTableView.hidden = YES;
    searchTextField.text = nil;
    [searchTextField resignFirstResponder];
}


-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultUsers.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *findFriendsCellIdentifier = @"find_friends";
    
    CHFindFriendsCell *cell = (CHFindFriendsCell*) [tableView dequeueReusableCellWithIdentifier:findFriendsCellIdentifier];
   
    CHUser* user = self.searchResultUsers[indexPath.row];
    NSString* userName = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
    [[cell nameLabel] setText:userName];
    [[cell photoImageView] setImageWithURL:[user avatarURL]];

    cell.photoImageView.layer.cornerRadius = 17.0f;
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHUser* user = self.searchResultUsers[indexPath.row];
    [self performSegueWithIdentifier:@"add_friend" sender:user];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"friends"]) {
        CHAddFriendsSocialNetworksVC* c = (CHAddFriendsSocialNetworksVC*)segue.destinationViewController;
        c.headerLabel.text = headerText;
    }else if ([segue.identifier isEqualToString:@"add_friend"]){
        CHAddFriendVC* vc = (CHAddFriendVC*)segue.destinationViewController;
        vc.currentUser = sender;
    }
}


@end
