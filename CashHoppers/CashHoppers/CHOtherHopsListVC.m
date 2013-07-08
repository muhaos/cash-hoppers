//
//  CHOtherHopsListVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/27/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHOtherHopsListVC.h"
#import "CHOtherHopsListCell.h"
#import "CHAppDelegate.h"
#import "MHCustomTabBarController.h"
#import "CHTradeShowEntryVC.h"

@interface CHOtherHopsListVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;

@end

@implementation CHOtherHopsListVC

@synthesize otherHopsTable;


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
    
    self.navigationItem.title = @"CASHH HOPPERS";
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.oldNavBarStatus = self.navigationController.navigationBarHidden;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *completeHopsCellIdentifier = @"complete_hops_list_cell";
    static NSString *previewHopsCellIdentifier = @"preview_hops_list_cell";
    static NSString *joinHopsCellIdentifier = @"join_hops_list_cell";

    if (indexPath.section == 0) {
        CHOtherHopsListCell *cell = (CHOtherHopsListCell*) [tableView dequeueReusableCellWithIdentifier:completeHopsCellIdentifier];
        
        [[cell nameHopLabel] setText:@"Memorial Weekend HOP:"];
        [[cell dateHopLabel] setText:@"5/24 - 5/26"];
        [[cell namePrizeLabel] setText:@"Grand Prize:"];
        [[cell countPrizeLabel] setText:@"$100"];
        [[cell verticalIndicatorImageView] setImage:[UIImage imageNamed:@"vertical_indicator_green"]];
        [[cell horizontalIndicatorImageView] setImage:[UIImage imageNamed:@"horizontal_indicator_green"]];
        return cell;
    } else if (indexPath.section == 1) {
        CHOtherHopsListCell *cell = (CHOtherHopsListCell*) [tableView dequeueReusableCellWithIdentifier:previewHopsCellIdentifier];
        
        [[cell prewNameHopLabel] setText:@"Lowes Summer HOP:"];
        [[cell prewDateHopLabel] setText:@"July"];
        [[cell prewPrizeHopLabel] setText:@"Grand Prize:"];
        [[cell prewCountHopLabel] setText:@"$1000"];
        [[cell prewFeeLabel] setText:@"Entry Fee:"];
        [[cell prewCountFeeLabel] setText:@"$10"];
        [[cell prewVerticalIndicator] setImage:[UIImage imageNamed:@"av_indicator_cell"]];
        return cell;
    } else {
        CHOtherHopsListCell *cell = (CHOtherHopsListCell*) [tableView dequeueReusableCellWithIdentifier:joinHopsCellIdentifier];
        
        [[cell joinNameHopLabel] setText:@"NBM Trade Show HOP:"];
        [[cell joinDateHopLabel] setText:@"05/13/2013"];
        [[cell joinPrizeHopLabel] setText:@"Grand Prize:"];
        [[cell joinCountHopLabel] setText:@"$500"];
        [[cell joinVerticalIndicatorImageView] setImage:[UIImage imageNamed:@"av_indicator_cell"]];
        return cell;
    }
    return nil;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[CHTradeShowEntryVC sharedTradeShowEntryVC] showInController:self
//                                                         withText:@"NBM TRADE SHOW HOP"
//                                                        withImage:[UIImage imageNamed:@"image_nbm_show.png"]];

    
    [self performSegueWithIdentifier:@"tradeShowMulti" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)viewDidUnload {
    [self setOtherHopsTable:nil];
    [super viewDidUnload];
}
@end
