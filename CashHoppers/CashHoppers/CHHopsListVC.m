//
//  CHHopsListVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/21/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHopsListVC.h"
#import "CHHopsListCell.h"
#import "CHAppDelegate.h"
#import "MHCustomTabBarController.h"
#import "CHAdvertisingVC.h"

@interface CHHopsListVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;

@end

@implementation CHHopsListVC

@synthesize hopsTable;


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

    [[CHAdvertisingVC sharedAdverticingVC] showInController:self
                                            withHeaderLabel:@"VISIT BOOTH 315"
                                                  withImage:[UIImage imageNamed:@"reclama"]
                                      withBottomHeaderLabel:@"FOR A FREE T-SHIRT!"
                                            withBottomLabel:@"Next 10 visitors only"];
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
    if(section == 0) {
        return 2;
    } else {
        return 2;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height = 60;
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *yourHopsCellIdentifier = @"yourHops";
    static NSString *avHopsCellIdentifier = @"availableHops";
    
    if(indexPath.section == 0) {
        CHHopsListCell *cell = (CHHopsListCell*) [tableView dequeueReusableCellWithIdentifier:yourHopsCellIdentifier];
        [[cell yourDailyHopLable] setText:@"Monday, 5/21/2013"];
        [[cell yourJackpotLabel] setText:@"$10"];
        [[cell yourImageView] setImage:[UIImage imageNamed:@"your_indicator_cell"]];
        if (indexPath.row == 0) {
            [[cell your_delta] setImage:[UIImage imageNamed:@"delta_header_cell"]];
        }
        return cell;
    } else {
        CHHopsListCell *cell = (CHHopsListCell*) [tableView dequeueReusableCellWithIdentifier:avHopsCellIdentifier];
        [[cell avDailyHopLabel] setText:@"Monday, 5/21/2013"];
        [[cell avJackpotLabel] setText:@"$10"];
        [[cell availableImageView] setImage:[UIImage imageNamed:@"av_indicator_cell"]];
        if (indexPath.row == 0) {
            [[cell av_delta] setImage:[UIImage imageNamed:@"delta_header_cell"]];
        }
        return cell;
    }
    return nil;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [DELEGATE switchViewTo:CHNewHop];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section != 0) {
        return 10;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,34)];
     UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    if (section == 0) {
        img.image = [UIImage imageNamed:@"your_header_cell"];
    } else {
        img.image = [UIImage imageNamed:@"av_header_cell"];
    }
    [headerView addSubview:img];
    return headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,3)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setHopsTable:nil];
    [super viewDidUnload];
}

@end
