//
//  CHComposeMessageVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/26/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHComposeMessageVC.h"
#import "CHComposeMessageCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CHComposeMessageVC ()

@end

@implementation CHComposeMessageVC
@synthesize inputMessageTextView, searchTextField, userListTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    [self customInputTextView];
    [self customUserTableView];
    
    userListTable.hidden = YES;
}


-(void)customUserTableView
{
    userListTable.layer.cornerRadius = 3;
    userListTable.layer.borderColor = [UIColor colorWithRed:232.0f/256 green:232.0f/256 blue:232.0f/256 alpha:1.0f].CGColor;
    userListTable.layer.borderWidth = 1.0f;
}


-(void)customInputTextView
{
    inputMessageTextView.layer.cornerRadius = 3;
    inputMessageTextView.layer.borderColor = [UIColor colorWithRed:232.0f/256 green:232.0f/256 blue:232.0f/256 alpha:1.0f].CGColor;
    inputMessageTextView.layer.borderWidth = 1.0f;
    [inputMessageTextView setText:@"Compose message..."];
    [inputMessageTextView setTextColor:[UIColor colorWithRed:204.0f/256 green:204.0f/256 blue:204.0f/256 alpha:1.0f]];

}


- (void) backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}


-(void) textViewDidBeginEditing:(UITextView *)textView
{
    [inputMessageTextView setText:@""];
    [inputMessageTextView setTextColor:[UIColor colorWithRed:204.0f/256 green:204.0f/256 blue:204.0f/256 alpha:1.0f]];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    CGRect frame = self.view.frame; frame.origin.y = -30;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}


-(void) textViewDidEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2f];
    CGRect frame = self.view.frame; frame.origin.y = 0;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    userListTable.hidden = NO;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    userListTable.hidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setInputMessageTextView:nil];
    [self setSearchTextField:nil];
    [self setUserListTable:nil];
    [self setUserListTable:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userCellIdentifier = @"user_cell";
    
    CHComposeMessageCell *cell = (CHComposeMessageCell*) [tableView dequeueReusableCellWithIdentifier:userCellIdentifier];
    
    [[cell nameLabel] setText:@"Brian Kelly"];
    [[cell photoImageView] setImage:[UIImage imageNamed:@"photo_BrianKelly"]];
    
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (IBAction)sendMessageTapped:(id)sender
{
    
}


@end
