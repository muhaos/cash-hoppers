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
#import "CHUser.h"

@interface CHIndividualMessageVC ()

@property (nonatomic, retain) NSMutableArray* currentMessagesList;
@property (nonatomic, retain) id messageUpdatedNotification;
@property (nonatomic, retain) id arrivedMessagesNotification;
@property (nonatomic, assign) BOOL needAnimatedScroll;
@property (nonatomic, retain) UIButton* backButton;

@end

@implementation CHIndividualMessageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    [self setupEditButton];
    
    self.inputMessageTextView.layer.cornerRadius = 3;
    self.inputMessageTextView.layer.borderColor = [UIColor colorWithRed:232.0f/256 green:232.0f/256 blue:232.0f/256 alpha:1.0f].CGColor;
    self.inputMessageTextView.layer.borderWidth = 1.0f;
    [self.inputMessageTextView setText:@"Reply to message ..."];
    [self.inputMessageTextView setTextColor:[UIColor colorWithRed:204.0f/256 green:204.0f/256 blue:204.0f/256 alpha:1.0f]];
    
    self.needAnimatedScroll = NO;
    
    [self reloadMessages];
    
    
    self.messageUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_MESSAGE_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        
        CHMessage* msg = note.object;
        NSUInteger index = [self.currentMessagesList indexOfObject:msg];
        if (index != NSNotFound) {
            [self.messagesTable beginUpdates];
            [self.messagesTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.messagesTable endUpdates];
        }
        
    }];

    
    self.arrivedMessagesNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_NEW_MESSAGES_ARRIVED object:nil queue:nil usingBlock:^(NSNotification* note) {
        
        NSArray* messages = note.object;
        for (CHMessage* m in messages) {
            if ([m.sender_id intValue] == [self.currentFriendID intValue]) {
                [self reloadMessages];
                break;
            }
        }
    }];
}


- (void) setupEditButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"button_edit"];
    [backBtn setImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(editButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 43, 17);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.backButton = backBtn;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.rightBarButtonItem = backButton;
}


- (void) editButtonTapped {
    self.messagesTable.editing = !self.messagesTable.editing;
    if (self.messagesTable.editing) {
        UIImage *backBtnImage = [UIImage imageNamed:@"button_done"];
        [self.backButton setImage:backBtnImage forState:UIControlStateNormal];
    } else {
        UIImage *backBtnImage = [UIImage imageNamed:@"button_edit"];
        [self.backButton setImage:backBtnImage forState:UIControlStateNormal];
    }
}


- (void) reloadMessages {
    [[CHMessagesManager instance] loadMessagesHistoryForFriendID:self.currentFriendID withCompletionHandler:^(NSArray* messages){
        self.currentMessagesList = [messages mutableCopy];
        [self.messagesTable reloadData];
        [self.messagesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.currentMessagesList count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:self.needAnimatedScroll];
        self.needAnimatedScroll = YES;
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
    
    CHMessage* message = [self.currentMessagesList objectAtIndex:indexPath.row];
    
    CGSize maximumLabelSize = CGSizeMake(309.0f, 9999.0f);
    CGSize expectedLabelSize = [message.text sizeWithFont:[UIFont fontWithName:@"DroidSans" size:12.0f] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    
    return expectedLabelSize.height + 90.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *messagesCellIdentifier = @"individual_message_cell";
    
    CHIndividualMessageCell *cell = (CHIndividualMessageCell*) [tableView dequeueReusableCellWithIdentifier:messagesCellIdentifier];
    
    CHMessage* message = [self.currentMessagesList objectAtIndex:indexPath.row];
    if (message.senderUser == nil) {
        cell.nameLabel.text = @"";
    } else {
        NSString* friendName = [NSString stringWithFormat:@"%@ %@", message.senderUser.first_name, message.senderUser.last_name];
        cell.nameLabel.text = friendName;
    }
    [cell.avatarImageView setImageWithURL:[message.senderUser avatarURL]];
    cell.messageTextView.text = message.text;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ ago", message.time_ago];

    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    CHMessage* message = [self.currentMessagesList objectAtIndex:indexPath.row];
    if ([message.sender_id intValue] != [self.currentFriendID intValue]) {
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CHMessage* message = [self.currentMessagesList objectAtIndex:indexPath.row];
        
        [[CHMessagesManager instance] removeMessage:message withCompletionHandler:^(NSError* error) {
            if (error == nil) {
                NSUInteger index = [self.currentMessagesList indexOfObject:message];
                if (index != NSNotFound) {
                    [self.currentMessagesList removeObject:message];
                    [self.messagesTable beginUpdates];
                    [self.messagesTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.messagesTable endUpdates];
                }
            }
        }];
    }
}



#pragma mark -
#pragma mark UITextViewDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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
    [self.inputMessageTextView resignFirstResponder];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self.messageUpdatedNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.arrivedMessagesNotification];
    [self setInputMessageTextView:nil];
    [super viewDidUnload];
}



@end
