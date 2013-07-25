//
//  CHFindFriendsVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFindFriendsVC.h"
#import "CHAddFriendsSocialNetworksVC.h"

@interface CHFindFriendsVC ()

@end

@implementation CHFindFriendsVC
@synthesize headerText;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        c.view;
        c.headerLabel.text = headerText;
    }
}


- (IBAction)twitterFriendsTapped:(id)sender {
    headerText = @"TWITTER FRIENDS";
    [self performSegueWithIdentifier:@"friends" sender:self];
}


- (IBAction)facebookFriendsTapped:(id)sender {
    headerText = @"FACEBOOK FRIENDS";
    [self performSegueWithIdentifier:@"friends" sender:self];
}


- (IBAction)googleFriendsTapped:(id)sender {
    headerText = @"GOOGLE PLUS FRIENDS";
    [self performSegueWithIdentifier:@"friends" sender:self];
}


- (IBAction)sendEmailTapped:(id)sender {
 //   [self performSegueWithIdentifier:@"friends" sender:self];
}


@end
