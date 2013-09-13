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
#import "CHSelectedUserView.h"
#import "CHUserManager.h"
#import "CHMessagesManager.h"

@interface CHComposeMessageVC ()
{
    NSMutableArray *selectedUserArray;
    NSMutableArray* selectedUserViews;
    NSArray* searchResultUsers;
}

@end

@implementation CHComposeMessageVC
@synthesize inputMessageTextView, searchTextField, userListTable, containerView, searchImageView, bottomView, scroolView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    [self customInputTextView];
    [self customUserTableView];
    [self customContainerView];
    
    selectedUserArray = [[NSMutableArray alloc] init];
    selectedUserViews = [NSMutableArray new];
    userListTable.hidden = YES;
    
    
    searchResultUsers = @[];
    
    [[CHUserManager instance] loadFriendsWithCompletionHandler:^(NSArray* friends) {
        searchResultUsers = friends;
        [userListTable reloadData];
    }];
    
    [self loyoutSearchView];
    self.scroolView.contentSize = CGSizeMake(320.0f, self.view.bounds.size.height + 100.0f);
}


-(void)customContainerView
{
    containerView.layer.cornerRadius = 3.0f;
    containerView.layer.borderWidth = 1.0f;
    containerView.layer.borderColor = [UIColor colorWithRed:232.0f/256 green:232.0f/256 blue:232.0f/256 alpha:1.0f].CGColor;
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


#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchResultUsers.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *userCellIdentifier = @"user_cell";
    
    CHComposeMessageCell *cell = (CHComposeMessageCell*) [tableView dequeueReusableCellWithIdentifier:userCellIdentifier];
    
    CHUser* user = searchResultUsers[indexPath.row];
    NSString* userName = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
    [[cell nameLabel] setText:userName];
    [[cell photoImageView] setImageWithURL:[user avatarURL] placeholderImage:[UIImage imageNamed: @"spinner.png"]];
    
    cell.accessoryView = nil;
    if ([selectedUserArray containsObject:user]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [imageView setImage:[UIImage  imageNamed:@"compose_icon.png"]];
        cell.accessoryView = imageView;
    } else {
    }
        
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHComposeMessageCell *cell = (CHComposeMessageCell*) [tableView cellForRowAtIndexPath:indexPath];
    CHUser* tappedUser = searchResultUsers[indexPath.row];
    
    cell.accessoryView = nil;
    
    if ([selectedUserArray containsObject:tappedUser]) {
        [selectedUserArray removeObject:tappedUser];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [imageView setImage:[UIImage  imageNamed:@"compose_icon.png"]];
        cell.accessoryView = imageView;
        [selectedUserArray addObject:tappedUser];
    }

    [self loyoutSearchView];
    [self scrollToFindTextField];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void) scrollToFindTextField
{
    CGPoint offset = CGPointMake(0 ,searchTextField.frame.origin.y +30);
    [self.scroolView setContentOffset:offset animated:YES];
}


-(void)loyoutSearchView
{
    int rowsNum = ceilf([selectedUserArray count] / 3.0f);
    
    float containerHeight = 35.0f * rowsNum + 40.0f;
    
    containerView.frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y, containerView.frame.size.width, containerHeight);
  
    float userTableY = containerView.frame.origin.y+containerHeight;
    userListTable.frame = CGRectMake(userListTable.frame.origin.x, userTableY, userListTable.frame.size.width, userListTable.frame.size.height);
    
    for (CHSelectedUserView* userView in selectedUserViews) {
        [userView.view removeFromSuperview];
    }
    [selectedUserViews removeAllObjects];
    
    for (int row = 0; row < rowsNum; row ++) {
        
        for (int i=0; i<3; i++){
            
            if ((row * 3 + i)+1 > selectedUserArray.count) {
                break;
            }
            
            CHSelectedUserView* selectedUserView = [[CHSelectedUserView alloc] init];
            CHUser* user = selectedUserArray[row * 3 + i];
            NSString* userName = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
            
            selectedUserView.view.layer.cornerRadius = 2.0f;
            selectedUserView.nameLabel.text = userName;
            [selectedUserView.photoImageView setImageWithURL:[user avatarURL] placeholderImage:[UIImage imageNamed: @"spinner.png"]];
            
            [containerView addSubview:selectedUserView.view];
            selectedUserView.view.frame = CGRectMake(i * 90+10, row * 30+5, 80, 25);
            [selectedUserViews addObject:selectedUserView];
            
            selectedUserView.user = user;
            
            UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userViewTapped:)];
            [selectedUserView.view addGestureRecognizer:gr];
            
            bottomView.frame = CGRectMake(20, containerView.frame.origin.y+containerHeight+20, 280, 200);
        }
    }
}


- (void) userViewTapped:(UIGestureRecognizer*) gr {
    for (CHSelectedUserView* v in selectedUserViews) {
        if (v.view == gr.view) {
            [selectedUserArray removeObject:v.user];
        }
    }

    [self loyoutSearchView];
    [self.userListTable reloadData];
}


- (IBAction)sendMessageTapped:(id)sender
{
    if (![inputMessageTextView.text isEqualToString:@"Compose message..."]) {
        ((UIButton*)sender).enabled = NO;
        inputMessageTextView.editable = NO;
        
        NSMutableArray* recepientIDs = [NSMutableArray new];
    
        for (CHUser* user in selectedUserArray) {
            [recepientIDs addObject:user.identifier];
        }
        
        [[CHMessagesManager instance] postMessageWithText:inputMessageTextView.text toFriendsList:recepientIDs completionHandler:^(NSError* error){
            
            ((UIButton*)sender).enabled = YES;
            inputMessageTextView.editable = YES;
        
            if (error == nil) {
                inputMessageTextView.text = @"";
                UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"SUCCESS" message:@"Message sended" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [av show];
            }
        }];
    }
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
    [self setContainerView:nil];
    [self setSearchImageView:nil];
    [self setBottomView:nil];
    [self setScroolView:nil];
    [super viewDidUnload];
}

@end
