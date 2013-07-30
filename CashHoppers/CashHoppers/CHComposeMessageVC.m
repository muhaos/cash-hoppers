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

@interface CHComposeMessageVC ()
{
    NSMutableArray *selectedUserArray;
    NSMutableArray* selectedUserViews;
    NSArray* searchResultUsers;
}

@end

@implementation CHComposeMessageVC
@synthesize inputMessageTextView, searchTextField, userListTable, containerView, searchImageView, bottomView;

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
    
    
    searchResultUsers = @[@"Test User1", @"Test User2", @"Test User3", @"Test User4"];
    
    [self loyoutSearchView];
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
    
    [[cell nameLabel] setText:searchResultUsers[indexPath.row]];
    [[cell photoImageView] setImage:[UIImage imageNamed:@"photo_BrianKelly"]];
        
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHComposeMessageCell *cell = (CHComposeMessageCell*) [tableView cellForRowAtIndexPath:indexPath];
    NSString* tappedUser = searchResultUsers[indexPath.row];
    
    if ([selectedUserArray containsObject:tappedUser]) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.accessoryView = nil;
        [selectedUserArray removeObject:tappedUser];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        [imageView setImage:[UIImage  imageNamed:@"compose_icon.png"]];
        cell.accessoryView = imageView;
        [selectedUserArray addObject:tappedUser];
    }

    [self loyoutSearchView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)loyoutSearchView
{
    int rowsNum = ceilf([selectedUserArray count] / 3.0f);
    
    float containerHeight = 35.0f * rowsNum + 35.0f;
    
    containerView.frame = CGRectMake(containerView.frame.origin.x, containerView.frame.origin.y, containerView.frame.size.width, containerHeight);
  
    float userTableY = containerView.frame.origin.y+containerHeight;
    userListTable.frame = CGRectMake(userListTable.frame.origin.x, userTableY, userListTable.frame.size.width, (self.view.frame.size.height + 44) - userTableY - 216);
    
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
            
            selectedUserView.view.layer.cornerRadius = 2.0f;
            selectedUserView.nameLabel.text = selectedUserArray[row * 3 + i];
            selectedUserView.photoImageView.image = [UIImage imageNamed:@"photo_BrianKelly"];
            
            [containerView addSubview:selectedUserView.view];
            selectedUserView.view.frame = CGRectMake(i * 90+10, row * 30+5, 80, 25);
            [selectedUserViews addObject:selectedUserView];
            
            bottomView.frame = CGRectMake(20, containerView.frame.origin.y+containerHeight+20, 280, 200);
        }
    }
}


- (IBAction)sendMessageTapped:(id)sender
{
    
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
    [super viewDidUnload];
}

@end
