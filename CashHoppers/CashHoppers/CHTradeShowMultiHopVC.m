//
//  CHTradeShowItemHopVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/8/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHTradeShowMultiHopVC.h"
#import "CHTradeShowMultiHopCell.h"
#import "CHTradeShowEntryVC.h"

@interface CHTradeShowMultiHopVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;

@end

@implementation CHTradeShowMultiHopVC
@synthesize multiHopTable;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"button_nav_back"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.hopTitleLabel.text = @"NBM TRADE SHOW HOP - 6/4/13";
    self.hopImageView.image = [UIImage imageNamed:@"image_nbm_show.png"];
    self.scoreLabel.text = @"550 pts";
    self.rankLabel.text = @"3 of 46";
    self.grandPrizeLabel.text = @"$ 550";
    
    [[CHTradeShowEntryVC sharedTradeShowEntryVC] showInController:self
                                                         withText:@"NBM TRADE SHOW HOP"
                                                        withImage:[UIImage imageNamed:@"image_nbm_show.png"]];
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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *completeHopsCellIdentifier = @"complete_cell";
    static NSString *notCompleteHopsCellIdentifier = @"not_complete_cell";
    
    if (indexPath.section == 0) {
        CHTradeShowMultiHopCell *cell = (CHTradeShowMultiHopCell*) [tableView dequeueReusableCellWithIdentifier:completeHopsCellIdentifier];
        
        [[cell compTextView] setText:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu."];
        [[cell compVerticalIndicatorImageView] setImage:[UIImage imageNamed:@"vertical_indicator_green"]];
        [[cell completeIndicatorImageView] setImage:[UIImage imageNamed:@"horizontal_indicator_green"]];
        return cell;
    } else if (indexPath.section == 1) {
        CHTradeShowMultiHopCell *cell = (CHTradeShowMultiHopCell*) [tableView dequeueReusableCellWithIdentifier:notCompleteHopsCellIdentifier];
        
        [[cell notCompTextView] setText:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu."];
        [[cell notCompVerticalIndicatorImageView] setImage:[UIImage imageNamed:@"your_indicator_cell.png"]];
        return cell;
    } else {
        return nil;
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setMultiHopTable:nil];
    [self setHopImageView:nil];
    [self setScoreLabel:nil];
    [self setRankLabel:nil];
    [self setGrandPrizeLabel:nil];
    [self setHopTitleLabel:nil];
    [super viewDidUnload];
}


@end
