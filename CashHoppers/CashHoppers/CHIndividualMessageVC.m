//
//  CHComposeNewMessageVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHIndividualMessageVC.h"
#import <QuartzCore/QuartzCore.h>
#import "CHIndividualMessageCell.h"
#import "CHMessagesManager.h"
#import "AFNetworking.h"

@interface CHIndividualMessageVC ()

@property (nonatomic, retain) NSArray* currentMessagesList;

@end

@implementation CHIndividualMessageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    
    self.inputMessageTextView.layer.cornerRadius = 3;
    self.inputMessageTextView.layer.borderColor = [UIColor colorWithRed:232.0f/256 green:232.0f/256 blue:232.0f/256 alpha:1.0f].CGColor;
    self.inputMessageTextView.layer.borderWidth = 1.0f;
    [self.inputMessageTextView setText:@"Reply to message ..."];
    [self.inputMessageTextView setTextColor:[UIColor colorWithRed:204.0f/256 green:204.0f/256 blue:204.0f/256 alpha:1.0f]];
    
    [self reloadMessages];
}


- (void) reloadMessages {
    [[CHMessagesManager instance] loadMessagesHistoryForFriendID:self.currentFriendID withCompletionHandler:^(NSArray* messages){
        self.currentMessagesList = messages;
        [self.messagesTable reloadData];
        [self.messagesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.currentMessagesList count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

- (void) backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentMessagesList count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 124;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *messagesCellIdentifier = @"individual_message_cell";
    
    CHIndividualMessageCell *cell = (CHIndividualMessageCell*) [tableView dequeueReusableCellWithIdentifier:messagesCellIdentifier];
    
    CHMessage* message = [self.currentMessagesList objectAtIndex:indexPath.row];
    
//    NSString* friendName = [NSString stringWithFormat:@"%@ %@", message.friend_first_name, message.friend_last_name];
    
    //[cell.avatarImageView setImageWithURL:];
    cell.messageTextView.text = message.text;
    
    return cell;
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
    [self.inputMessageTextView setText:@""];
    [self.inputMessageTextView setTextColor:[UIColor colorWithRed:204.0f/256 green:204.0f/256 blue:204.0f/256 alpha:1.0f]];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    CGRect frame = self.view.frame; frame.origin.y = -160;
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



- (IBAction)deleteButtonTapped:(id)sender
{
    
}


- (IBAction)replyMessageButtonTapped:(id)sender
{
    ((UIButton*)sender).enabled = NO;
    self.inputMessageTextView.editable = NO;
    
    NSArray* recepientIDs = @[self.currentFriendID];
    
    [[CHMessagesManager instance] postMessageWithText:self.inputMessageTextView.text toFriendsList:recepientIDs completionHandler:^(NSError* error){
        
        ((UIButton*)sender).enabled = YES;
        self.inputMessageTextView.editable = YES;
        
        if (error == nil) {
            self.inputMessageTextView.text = @"";
            [self reloadMessages];
        }
        
    }];
}

- (IBAction)composeNewMessageTapped:(id)sender
{
    [self performSegueWithIdentifier:@"compose_message" sender:self];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setInputMessageTextView:nil];
    [super viewDidUnload];
}



@end
