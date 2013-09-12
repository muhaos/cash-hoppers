//
//  CHDetailsFeedVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/9/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHDetailsFeedVC.h"
#import <QuartzCore/QuartzCore.h>
#import "CHCommentListCell.h"
#import "CHFriendsFeedManager.h"
#import "CHFriendsFeedItem.h"
#import "CHUser.h"
#import "CHHop.h"
#import "CHFeedItemComment.h"
#import "AFNetworking.h"
#import "CHUserManager.h"
#import "CHAddFriendVC.h"

@interface CHDetailsFeedVC ()
@property (assign, nonatomic) BOOL oldNavBarStatus;
@end

@implementation CHDetailsFeedVC
@synthesize commentTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customUIElement];
    [self setupTriangleBackButton];
    
    NSString *name = _feedItem.user.first_name;
    NSString *lastName = _feedItem.user.last_name;
    NSString *namePersonText = [name stringByAppendingFormat:@" %@",lastName];
    self.namePersonLabel.text = namePersonText;
    self.photoPersonImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_feedItem.user.avatarURL]];
    self.nameHopLabel.text = _feedItem.hop.name;
    self.taskCompletedLabel.text = _feedItem.completedTaskName;
    [self.photoHopImageView setImageWithURL:_feedItem.hopImageURL placeholderImage:[UIImage imageNamed: @"spinner.png"]];
    self.countLikeLabel.text = [_feedItem.numberOfLikes stringValue];
    _timeLabel.text = [NSString stringWithFormat:@"%@ ago", _feedItem.time_ago];
    
    NSString* likersSrt = @"";
    for (NSString* likerName in _feedItem.likers) {
        likersSrt = [likersSrt stringByAppendingString:likerName];
        if (likerName != [_feedItem.likers lastObject]) {
            likersSrt = [likersSrt stringByAppendingString:@", "];
        }
    }
    self.likedPersonsLabel.text = likersSrt;
    
    _myScroolView.contentSize = CGSizeMake(320, 900);
    self.addComentTextView.text = @"Add coment ...";
    self.addComentTextView.textColor = [UIColor grayColor];

    if([_feedItem.liked integerValue]==0){
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"like_icon_off"] forState:UIControlStateNormal];
    }else{
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"like_icon_on"] forState:UIControlStateNormal];
    }
    
    if (_feedItem.user.friendship_status == nil && [_feedItem.user.identifier intValue] != [[CHUserManager instance].currentUser.identifier intValue]) {
        self.postCommentButton.hidden = YES;
        self.addComentTextView.hidden = YES;
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"like_icon_on"] forState:UIControlStateNormal];
        if (self.comments.count == 0) {
            self.addFriendButton.frame = CGRectMake(95, 500, 152, 44);
        }
    } else {
        self.addFriendButton.hidden = YES;
    }
    
    [self reloadData];
    [self registerForNotifications];
    
}


#pragma mark - notifications

-(void)registerForNotifications{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(resizeViewForKeyboard) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(resizeViewToNormalSize) name:UIKeyboardWillHideNotification object:nil];
//    [nc addObserver:self selector:@selector(refreshData) name:CH_COMMENTS_RECEIVED object:nil];
    [nc addObserver:self selector:@selector(refreshComment:) name:CH_FEED_ITEM_COMMENT_UPDATED object:nil];

    
}

-(void)unregisterForNotifications{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
}

#pragma mark - keyboard func.

-(void)resizeViewToNormalSize{
    CGRect newFrame = [UIApplication sharedApplication].keyWindow.frame;
    newFrame.size.height -= 110;
    [UIView animateWithDuration:0.3f animations:^{
        self.myScroolView.frame = newFrame;
    }];
}

-(void)resizeViewForKeyboard{
    
    CGRect newFrame = self.view.frame;
    newFrame.size.height -= [self keyboardSize].height;
    [UIView animateWithDuration:0.2f animations:^{
        self.myScroolView.frame = newFrame;
    }completion:^(BOOL finished) {
        [_myScroolView scrollRectToVisible:_postCommentButton.frame animated:YES];
    }];
    

}


-(CGSize)keyboardSize{
    if(USING_IPAD){
        return  CGSizeMake(self.view.frame.size.width, 450);
    }else{
        return  CGSizeMake(self.view.frame.size.width, 180);
    }
}

-(void)reloadData{
    
    [[CHFriendsFeedManager instance] loadCommentsForFeedItem:_feedItem completionHandler:^(NSArray *coments) {
        self.comments = [NSMutableArray arrayWithArray:coments];
        [self refreshData];
    }];
}

-(void)refreshData{
    
    self.countCommentLabel.text =  [NSString stringWithFormat:@"%d",_comments.count];
    
    [commentTable reloadData];
    
    [self refreshElementsSizeAndPosition];
    
}

-(void)refreshComment:(NSNotification*)notification{

    CHFeedItemComment *comment  = (CHFeedItemComment*)notification.object;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_comments indexOfObject:comment] inSection:0];

    [commentTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

-(void)refreshElementsSizeAndPosition{
    
    float offset = commentTable.contentSize.height - commentTable.frame.size.height;
    
    //    increase scrollview size
    
    CGSize newSize = _myScroolView.contentSize;
    newSize.height += offset;
    _myScroolView.contentSize = newSize;
    
    //    move post button down
    CGRect postButtonFrame = _postCommentButton.frame;
    postButtonFrame.origin.y += offset;
    _postCommentButton.frame = postButtonFrame;
    
    //    move textview down
    CGRect textViewFrame = _addComentTextView.frame;
    textViewFrame.origin.y += offset;
    _addComentTextView.frame = textViewFrame;
    
    //    increase tableview size
    CGRect newTableRect = commentTable.frame;
    newTableRect.size = commentTable.contentSize;
    commentTable.frame = newTableRect;
    
}

-(void) customUIElement
{
    self.photoPersonImageView.layer.cornerRadius = 25.0f;
    self.photoHopImageView.layer.cornerRadius = 10.0;
    self.photoPersonImageView.layer.masksToBounds = YES;
    self.photoHopImageView.layer.masksToBounds = YES;
    self.countLikeLabel.layer.cornerRadius = 3.0f;
    self.countCommentLabel.layer.cornerRadius = 3.0f;
    self.addComentTextView.layer.cornerRadius = 5.0f;
    self.postCommentButton.layer.cornerRadius = 10.0f;
    self.addComentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.addComentTextView.layer.borderWidth = 1.0f;
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.oldNavBarStatus = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _comments.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *text = ((CHFeedItemComment*)[_comments objectAtIndex:indexPath.row]).text;

    int labelHeight = [self calculateLabelHeight:nil ForText:text];
    
    return labelHeight+30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *commentCellIdentifier = @"comment";
    CHCommentListCell *cell = (CHCommentListCell*) [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    CHFeedItemComment *feedComment = (CHFeedItemComment*)[_comments objectAtIndex:indexPath.row];
    NSString *nameString = [feedComment.user.first_name stringByAppendingFormat:@" %@:",feedComment.user.last_name];
    cell.nameLabel.text = nameString;
    [self calculateLabelHeight:cell.commentLabel ForText:feedComment.text];
    [[cell commentLabel] setText:feedComment.text];
    [cell photoPerson].layer.cornerRadius = 15.0f;
    [cell photoPerson].layer.masksToBounds = YES;
    [[cell photoPerson] setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:feedComment.user.avatarURL]]];
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)calculateLabelHeight:(UILabel*)label ForText:(NSString*)text{
    
    if(!label){
        CHCommentListCell *cell = [commentTable dequeueReusableCellWithIdentifier:@"comment"];
        label = cell.commentLabel;
    }
    label.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width,9999);
    
    CGSize expectedLabelSize = [text sizeWithFont:label.font
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
        
    return newFrame.size.height;
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
    textView.text = @"";
    textView.textColor = [UIColor darkGrayColor];
}

-(void)hideKeyboard{
    
    [self.view endEditing:YES];
}
#pragma mark - rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation)?YES:NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self unregisterForNotifications];
    [self setPhotoPersonImageView:nil];
    [self setNamePersonLabel:nil];
    [self setTimeLabel:nil];
    [self setNameHopLabel:nil];
    [self setTaskCompletedLabel:nil];
    [self setPhotoHopImageView:nil];
    [self setCountLikeLabel:nil];
    [self setCountCommentLabel:nil];
    [self setCommentTable:nil];
    [self setAddComentTextView:nil];
    [self setPostCommentButton:nil];
    [self setMyScroolView:nil];
    [self setLikedPersonsLabel:nil];
    [self setLikeButton:nil];
    [self setAddFriendButton:nil];
    [super viewDidUnload];
}


- (IBAction)likePressed:(id)sender {
    if (_feedItem.user.friendship_status != nil) {
        if([_feedItem.liked boolValue]){
            return;
        }
        
        [[CHFriendsFeedManager instance]postLikeForFeedItem:_feedItem completionHandler:^(NSError *error) {
            if(!error){
                [_likeButton setBackgroundImage:[UIImage imageNamed:@"like_icon_on"] forState:UIControlStateNormal];
                _feedItem.liked = @1;
                _feedItem.numberOfLikes = @([_feedItem.numberOfLikes intValue]+1);
                _countLikeLabel.text = [NSString stringWithFormat:@"%d", [_feedItem.numberOfLikes intValue]];
                }
        }];
        
        NSMutableString *likersSrt = [NSMutableString new];
        for (NSString* likerName in _feedItem.likers) {
            [likersSrt appendString:likerName];
            
            if (likerName != [_feedItem.likers lastObject]) {
                [likersSrt appendString:@", "];
            }
        }
        
        if (likersSrt.length == 0){
            [likersSrt appendFormat:@"%@ %@ ",self.feedItem.user.first_name, self.feedItem.user.last_name];
        }else{
            [likersSrt appendFormat:@"%@, %@ %@ ", likersSrt, self.feedItem.user.first_name, self.feedItem.user.last_name];
        }
        
        self.likedPersonsLabel.text = likersSrt;
    }
}


- (IBAction)postCommentTapped:(id)sender {
    if (_feedItem.user.friendship_status != nil) {
        if (![self.addComentTextView.text isEqual: @"Add coment ..."]) {
            _postCommentButton.enabled = FALSE;
            [[CHFriendsFeedManager instance] postCommentForFeedItem:_feedItem withText:_addComentTextView.text completionHandler:^(BOOL success) {
                _postCommentButton.enabled = TRUE;
                [self reloadData];
            }];
        }
    }
    self.addComentTextView.text = @"";
    [self.addComentTextView resignFirstResponder];
}


- (IBAction)scrollViewTapped:(id)sender {
    
    [self hideKeyboard];
}


- (IBAction)addFriendButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"detail_add_friend" sender:_feedItem.user];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detail_add_friend"]) {
        ((CHAddFriendVC*)segue.destinationViewController).currentUser = sender;
    }
}


@end
