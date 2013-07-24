//
//  CHFriendsListVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/25/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHFriendsListVC.h"
#import "CHFriendsListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CHFriendsFeedManager.h"
#import "CHFriendsFeedItem.h"
#import "CHUser.h"
#import "CHHopTask.h"
#import "CHHop.h"

@interface CHFriendsListVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;
@property (assign, nonatomic) BOOL friendsButtonActive;

@end

@implementation CHFriendsListVC
@synthesize friendsTable;
@synthesize friendsFeedManager;
@synthesize friendsFeed;
@synthesize globalFeed;
@synthesize hopsImages;

- (void)viewDidLoad
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"button_nav_back"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    [self refreshList];
    self.friendsButtonActive = YES;
    [self activeButton:YES];
    
    self.hopsImages = [NSMutableArray arrayWithCapacity:1];
    [self registerForNotifications];
    self.friendsFeedManager = [[CHFriendsFeedManager alloc]init];
    [friendsFeedManager loadFriendsFeed];
    [friendsFeedManager loadGlobalFeed];
//    [self performSelector:@selector(show) withObject:nil afterDelay:3];

}

-(void)registerForNotifications{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(refreshList) name:CH_FRIEND_FEED_UPDATED object:nil];
    [nc addObserver:self selector:@selector(refreshList) name:CH_GLOBAL_FEED_UPDATED object:nil];

}

-(void)unRegisterForNotifications{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

-(void)refreshList{

    self.friendsFeed = friendsFeedManager.friendsFeed;
    self.globalFeed = friendsFeedManager.globalFeed;
    NSArray *dataSource = self.friendsButtonActive?friendsFeed:globalFeed;
    for(int index=0;index<dataSource.count;index++){
        [self.hopsImages addObject:[NSNull null]];
    }
    

    [self.friendsTable reloadData];
    
    NSLog(@"feed = %@ global feed = %@",self.friendsFeed,self.globalFeed);
    
   
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
    return friendsFeed.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 157;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *friendsCellIdentifier = @"friends_list_cell";
    
    CHFriendsListCell *cell = (CHFriendsListCell*) [tableView dequeueReusableCellWithIdentifier:friendsCellIdentifier];
    
    NSArray *feedArray = self.friendsButtonActive?friendsFeed:globalFeed;
    CHFriendsFeedItem *fItem = (CHFriendsFeedItem*)[feedArray objectAtIndex:indexPath.row];
    
    NSString *name = fItem.hopUser.firstName;
    NSString *lastName = fItem.hopUser.lastName;
    NSString *namePersonText = [name stringByAppendingFormat:@" %@",lastName];

    NSTimeInterval time = [fItem.hop.time_end timeIntervalSinceNow];
    int timeSinceCompleted = time/60;
    
    [[cell namePersonLabel] setText:namePersonText];
    [[cell nameHopLabel] setText:fItem.hopTask.text];
    [[cell timeLabel] setText:@"15 mins ago"];
    [[cell photoHopImageView] setImage:[UIImage imageNamed:@"photo_hop"]];
    [[cell photoPersonImageView] setImage:[UIImage imageNamed:@"photo_BrianKelly"]];
    [[cell taskCompletedLabel] setText:fItem.hopTask.completed];//@"Screen Printer"];
    [[cell addFriendButton] setImage:[UIImage imageNamed:@"button_add_friend"] forState:UIControlStateNormal];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%i m",timeSinceCompleted];
    cell.numberLikesLabel.text = [fItem.numberOfLikes stringValue];
    [cell numberCommentsLabel].layer.cornerRadius = 3.0f;
    [cell numberLikesLabel].layer.cornerRadius = 3.0f;
    
    [cell.imageView setImage:nil];
    
    NSData *const cachedImageData = [self.hopsImages objectAtIndex:indexPath.row];
//    NSLog(@"3333 =%@",self.hopsImages);
    if ([self.hopsImages objectAtIndex:indexPath.row]!=NULL && [cachedImageData isKindOfClass:[NSData class]]) {
        UIImage * PortraitImage = [[UIImage alloc] initWithCGImage: [UIImage imageWithData:cachedImageData].CGImage
                                                             scale: 1.0
                                                       orientation: UIImageOrientationRight];
        [cell.photoHopImageView setImage:PortraitImage];
    } else {
        [self downloadAndCacheImageForIndexPath:indexPath];
    }

    if (self.friendsButtonActive == YES) {
        
        [[cell commentButton] setHidden:NO];
        [[cell likeButton] setHidden:NO];
        [[cell numberCommentsLabel] setHidden:NO];
        [[cell numberLikesLabel] setHidden:NO];
        [[cell verticalSeparatorImageView] setHidden:NO];
        [[cell addFriendButton] setHidden:YES];
        
        if ([[cell numberCommentsLabel] isEqual: @""]  &&  [[cell numberLikesLabel] isEqual: @""]) {
            [[cell commentButton] setBackgroundImage:[UIImage imageNamed:@"comment_icon_n"] forState:UIControlStateNormal];
            [[cell likeButton] setBackgroundImage:[UIImage imageNamed:@"like_icon_n"] forState:UIControlStateNormal];
            [[cell numberCommentsLabel] setHidden:YES];
            [[cell numberLikesLabel] setHidden:YES];
        } else {
            [[cell commentButton] setBackgroundImage:[UIImage imageNamed:@"comment_icon_on"] forState:UIControlStateNormal];
            [[cell likeButton] setBackgroundImage:[UIImage imageNamed:@"like_icon_on"] forState:UIControlStateNormal];
            [[cell numberCommentsLabel] setText:@"10"];
            [[cell numberLikesLabel] setText:@"5"];
        }
    } else {
        [[cell commentButton] setHidden:YES];
        [[cell likeButton] setHidden:YES];
        [[cell numberCommentsLabel] setHidden:YES];
        [[cell numberLikesLabel] setHidden:YES];
        [[cell verticalSeparatorImageView] setHidden:YES];
        [[cell addFriendButton] setHidden:NO];
        
    }
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailsFeed" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)downloadAndCacheImageForIndexPath:(NSIndexPath *)indexPath {
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        NSArray *dataSource = self.friendsButtonActive?friendsFeed:globalFeed;
        CHFriendsFeedItem *fItem = (CHFriendsFeedItem*)[dataSource objectAtIndex:indexPath.row];
        NSLog(@"photo url = %@",fItem.photoURL);
        NSString *const imageStringURL = [NSString stringWithFormat:@"http://perechin.net:3000%@", fItem.photoURL];
        
        NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageStringURL]];
        [self.hopsImages replaceObjectAtIndex:indexPath.row withObject:image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.friendsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self unRegisterForNotifications];
    [self setFriendsTable:nil];
    [self setFriendsButton:nil];
    [self setAllHoppersButton:nil];
    [super viewDidUnload];
}


- (IBAction)friendsButtonTapped:(id)sender {
    self.friendsButtonActive = YES;
    [self activeButton:self.friendsButtonActive];
    [friendsTable reloadData];
}


- (IBAction)allHopppersButtonTapped:(id)sender {
    self.friendsButtonActive = NO;
    [self activeButton:self.friendsButtonActive];
    [friendsTable reloadData];
}

- (IBAction)addFriendTapped:(id)sender {
}


-(void)activeButton:(BOOL)friendsButton {
    if (friendsButton == YES) {
        [self.friendsButton setImage:[UIImage imageNamed:@"button_friends_ac"] forState:UIControlStateNormal];
        [self.allHoppersButton setImage:[UIImage imageNamed:@"button_all_hops_no"] forState:UIControlStateNormal];
    } else {
        [self.friendsButton setImage:[UIImage imageNamed:@"button_friends_no"] forState:UIControlStateNormal];
        [self.allHoppersButton setImage:[UIImage imageNamed:@"button_all_hops_ac"] forState:UIControlStateNormal];
    }
}


@end
