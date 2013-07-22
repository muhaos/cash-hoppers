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
#import "CHHopsManager.h"
#import "CHTradeShowMultiHopVC.h"

@interface CHOtherHopsListVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;
@property (nonatomic, retain) id hopsUpdatedNotification;
@property (nonatomic, retain) NSArray* currentHopsList;
@property (nonatomic, strong) CHTradeShowEntryVC* currentPasswordVC;

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
    self.title = @"HOPS LIST";
    
    self.hopsUpdatedNotification = [[NSNotificationCenter defaultCenter] addObserverForName:CH_HOPS_UPDATED object:nil queue:nil usingBlock:^(NSNotification* note) {
        // refresh
        [self updateTable];
    }];

}


- (void) updateTable {
    if (self.isDailyHops) {
        self.hopsGroupTitleLabel.text = @"DAILY HOPS";
        self.currentHopsList = [CHHopsManager instance].dailyHop == nil ? @[] : @[[CHHopsManager instance].dailyHop];
    } else {
        self.hopsGroupTitleLabel.text = @"OTHER HOPS";
        self.currentHopsList = [CHHopsManager instance].otherHops;
    }
    [self.otherHopsTable reloadData];
}


- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.oldNavBarStatus = self.navigationController.navigationBarHidden;
    
    [self updateTable];
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
    return [self.currentHopsList count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *completeHopsCellIdentifier = @"complete_hops_list_cell";
    static NSString *previewHopsCellIdentifier = @"preview_hops_list_cell";
    static NSString *joinHopsCellIdentifier = @"join_hops_list_cell";

    CHHop* hop = self.currentHopsList[indexPath.row];
    CHOtherHopsListCell *cell = nil;
    
    switch ([hop hopType]) {
        case CHHopTypeCompleted: {
            cell = (CHOtherHopsListCell*) [tableView dequeueReusableCellWithIdentifier:completeHopsCellIdentifier];
            cell.currentHop = hop;
            [cell configureCompletedHop];
            break;
        }
        case CHHopTypeWithCode: {
            cell = (CHOtherHopsListCell*) [tableView dequeueReusableCellWithIdentifier:joinHopsCellIdentifier];
            cell.currentHop = hop;
            [cell configureHopWithCode];
            break;
        }
        case CHHopTypeWithEntryFee: {
            cell = (CHOtherHopsListCell*) [tableView dequeueReusableCellWithIdentifier:previewHopsCellIdentifier];
            cell.currentHop = hop;
            [cell configureHopWithFee];
            break;
        }
        case CHHopTypeFree: {
            cell = (CHOtherHopsListCell*) [tableView dequeueReusableCellWithIdentifier:completeHopsCellIdentifier];
            cell.currentHop = hop;
            [cell configureFreeHop];
            break;
        }
    }
    
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[CHTradeShowEntryVC sharedTradeShowEntryVC] showInController:self
//                                                         withText:@"NBM TRADE SHOW HOP"
//                                                        withImage:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_nbm_show.png"]]];
    
    //[self performSegueWithIdentifier:@"tradeShowMulti" sender:self.currentHopsList[indexPath.row]];
    CHHop* tappedHop = self.currentHopsList[indexPath.row];
    
    switch ([tappedHop hopType]) {
        case CHHopTypeCompleted: {
        }
        case CHHopTypeFree: {
        }
        case CHHopTypeWithEntryFee: {
            [self performSegueWithIdentifier:@"tradeShowMulti" sender:tappedHop];
            break;
        }
        case CHHopTypeWithCode: {
            self.currentPasswordVC = [[CHTradeShowEntryVC alloc] initWithNibName:@"CHTradeShowEntryVC" bundle:nil];
            self.currentPasswordVC.currentHop = tappedHop;
            self.currentPasswordVC.delegate = self;
            [self.view.window.rootViewController.view addSubview:self.currentPasswordVC.view];
            break;
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) tradeShowEntryVCClosedSucced:(BOOL) succed {
    if (succed) {
        [self performSegueWithIdentifier:@"tradeShowMulti" sender:self.currentPasswordVC.currentHop];
    }
    self.currentPasswordVC = nil;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"tradeShowMulti"]) {
        CHTradeShowMultiHopVC* vc = segue.destinationViewController;
        vc.currentHop = sender;
    }
    
}


- (void)viewDidUnload {
    [self setOtherHopsTable:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self.hopsUpdatedNotification];
    [super viewDidUnload];
}
@end
