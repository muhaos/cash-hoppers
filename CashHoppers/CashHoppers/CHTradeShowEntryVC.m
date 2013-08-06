//
//  CHTradeShowEntryVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/8/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHTradeShowEntryVC.h"
#import "CHHop.h"
#import "AFNetworking.h"

@interface CHTradeShowEntryVC ()

@end

@implementation CHTradeShowEntryVC

@synthesize tradeShowImageView,tradeShowLabel, passcodeTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];

    tradeShowLabel.text = self.currentHop.name;
    [tradeShowImageView setImageWithURL: [self.currentHop logoURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}


-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130;
    const float movementDuration = 0.3f;
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (void)viewDidUnload {
    [self setTradeShowImageView:nil];
    [self setTradeShowLabel:nil];
    [self setPasscodeTextField:nil];
    [super viewDidUnload];
}


- (IBAction)startPlayingTapped:(id)sender {
    if ([self.passcodeTextField.text isEqualToString:self.currentHop.code]) {
        [self.view removeFromSuperview];
        [self.delegate tradeShowEntryVCClosedSucced:YES];
    } else {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"PASSCODE" message:@"Incorrect passcode." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
    }
}


- (IBAction)cancelTapped:(id)sender {
    [self.view removeFromSuperview];
    [self.delegate tradeShowEntryVCClosedSucced:NO];
}


- (IBAction)helpTapped:(id)sender {
}


@end
