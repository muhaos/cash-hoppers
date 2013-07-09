//
//  CHTradeShowEntryVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/8/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHTradeShowEntryVC.h"

@interface CHTradeShowEntryVC ()

@end

@implementation CHTradeShowEntryVC

@synthesize tradeShowImageView,tradeShowLabel, passcodeTextField;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (CHTradeShowEntryVC*) sharedTradeShowEntryVC
{
    static CHTradeShowEntryVC* instance = nil;
    if (instance == nil) {
        instance = [[CHTradeShowEntryVC alloc] initWithNibName:@"CHTradeShowEntryVC" bundle:nil];
    }
    return instance;
}


- (void) showInController:(UIViewController*) c
                 withText:(NSString*) text
                withImage:(UIImageView*) image;
{
    if (self.view.superview != nil) {
        @throw [NSException exceptionWithName:@"CHTradeShowEntryVC" reason:@"TradeShowEntry controller already showed!" userInfo:nil];
    }
    [c.view addSubview:self.view];
    tradeShowLabel.text = text;
    tradeShowImageView = image;
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
//    [self performSegueWithIdentifier:@"tradeShowMulti" sender:self];
}


- (IBAction)cancelTapped:(id)sender {
    [self.view removeFromSuperview];
}


- (IBAction)helpTapped:(id)sender {
}


@end
