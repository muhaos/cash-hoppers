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
    
    self.namePersonLabel.text = @"Brian Kelly";
    self.photoPersonImageView.image = [UIImage imageNamed:@"photo_BrianKelly.png"];
    self.timeLabel.text = @"30 mins ago";
    self.nameHopLabel.text = @"NBM Trade show HOP";
    self.taskCompletedLabel.text = @"Screen Printer";
    self.photoHopImageView.image = [UIImage imageNamed:@"our_time.png"];
    self.countLikeLabel.text = @"4";
    self.countCommentLabel.text = @"3";
    self.likePersonTextView.text = @"Brad Daberko, Dan Kelly, Tony Fannin, Erin Kelly";
    _myScroolView.contentSize = CGSizeMake(320, 900);
    self.addComentTextView.text = @"Add coment ...";
    self.addComentTextView.textColor = [UIColor grayColor];
}


-(void) customUIElement
{
    self.photoPersonImageView.layer.cornerRadius = 10.0f;
    self.photoHopImageView.layer.cornerRadius = 10.0;
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *commentCellIdentifier = @"comment";
    CHCommentListCell *cell = (CHCommentListCell*) [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    [[cell commentTextView] setText:@"Brian Kelly: That`s a good picture. I should have taken a better one at that booth."];
    [cell photoPerson].layer.cornerRadius = 10.0f;
    [[cell photoPerson] setImage:[UIImage imageNamed:@"photo_brian.png"]];
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    textView.textColor = [UIColor blackColor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPhotoPersonImageView:nil];
    [self setNamePersonLabel:nil];
    [self setTimeLabel:nil];
    [self setNameHopLabel:nil];
    [self setTaskCompletedLabel:nil];
    [self setPhotoHopImageView:nil];
    [self setCountLikeLabel:nil];
    [self setCountCommentLabel:nil];
    [self setLikePersonTextView:nil];
    [self setCommentTable:nil];
    [self setAddComentTextView:nil];
    [self setPostCommentButton:nil];
    [self setMyScroolView:nil];
    [super viewDidUnload];
}


- (IBAction)postCommentTapped:(id)sender {
}


@end
