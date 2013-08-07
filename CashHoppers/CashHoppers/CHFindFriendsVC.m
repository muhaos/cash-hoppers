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

@interface CHFindFriendsVC ()

@end

@implementation CHFindFriendsVC
@synthesize headerText;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"mW5vfqMKEx1HGME7OeGCg" andSecret:@"RjiYj98WZSjKBbHn9r3hGYvMfptYPp5pQCP8h4gNH5A"];
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
    [super viewDidUnload];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"friends"]) {
        CHAddFriendsSocialNetworksVC* c = (CHAddFriendsSocialNetworksVC*)segue.destinationViewController;
        c.headerLabel.text = headerText;
    }
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
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    NSArray *emailAddresses = [[NSArray alloc] initWithObjects:nil];
    NSString *sendSubject = [[NSString alloc] initWithFormat:@" "];
    NSString *sendMessage = [[NSString alloc] initWithFormat:@"This is cashhoppers"];
    
    [mailComposer setToRecipients:emailAddresses];
    [mailComposer setSubject:sendSubject];
    [mailComposer setMessageBody:sendMessage isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:NULL];
}


-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
