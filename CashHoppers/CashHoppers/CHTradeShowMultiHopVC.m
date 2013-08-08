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
#import <CoreText/CoreText.h>
#import "CHNewHopVC.h"
#import "CHHopsManager.h"
#import "AFNetworking.h"

@interface CHTradeShowMultiHopVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;
@property (nonatomic, retain) id hopsTasksUpdatedNotification;

@end

@implementation CHTradeShowMultiHopVC
@synthesize multiHopTable;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    
    self.hopTitleLabel.text = [NSString stringWithFormat:@"%@   %@", self.currentHop.name, [self.currentHop dateString]];
    self.hopImageView.image = [UIImage imageNamed:@"image_nbm_show.png"];
    self.scoreLabel.text = @"550 pts";
    self.rankLabel.text = @"3 of 46";
    self.grandPrizeLabel.text = [NSString stringWithFormat:@"$%i", [self.currentHop.jackpot intValue]];
    [self.hopImageView setImageWithURL:[self.currentHop logoURL]];
    
    self.hopsTasksUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_HOPS_TASKS_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        // refresh
        if (note.object == self.currentHop) {
            [self.multiHopTable reloadData];
        }
    }];
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.oldNavBarStatus = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self showAdsWithType:@"ROFL" andHopID:self.currentHop.identifier];
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
    return [self.currentHop.tasks count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *completeHopsCellIdentifier = @"complete_cell";
    static NSString *notCompleteHopsCellIdentifier = @"not_complete_cell";
    
    CHHopTask* hopTask = [self.currentHop.tasks objectAtIndex:indexPath.row];
    CHTradeShowMultiHopCell *cell = nil;
    
    if ([hopTask.completed boolValue]) { // there must be check of hop task completion
        
        cell = (CHTradeShowMultiHopCell*) [tableView dequeueReusableCellWithIdentifier:completeHopsCellIdentifier];
        [[cell compTextLabel] setText:hopTask.text];
        [[cell compVerticalIndicatorImageView] setImage:[UIImage imageNamed:@"vertical_indicator_green"]];
        [[cell completeIndicatorImageView] setImage:[UIImage imageNamed:@"horizontal_indicator_green"]];

    } else {
        
        cell = (CHTradeShowMultiHopCell*) [tableView dequeueReusableCellWithIdentifier:notCompleteHopsCellIdentifier];
        [[cell notCompTextLabel] setText:hopTask.text];
        [[cell notCompVerticalIndicatorImageView] setImage:[UIImage imageNamed:@"your_indicator_cell.png"]];

    }
    

    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHHopTask* hopTask = [self.currentHop.tasks objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"new_hop_segue" sender:hopTask];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"new_hop_segue"]) {
        CHNewHopVC* c = (CHNewHopVC*)segue.destinationViewController;
        c.currentHopTask = sender;
    }
}


- (void)viewDidUnload {
    [self setMultiHopTable:nil];
    [self setHopImageView:nil];
    [self setScoreLabel:nil];
    [self setRankLabel:nil];
    [self setGrandPrizeLabel:nil];
    [self setHopTitleLabel:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.hopsTasksUpdatedNotification];
    [super viewDidUnload];
}




@end
