//
//  CHPushNotificationsVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/12/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHPushNotificationsVC.h"
#import "CHPushNotificationsCell.h"

@interface CHPushNotificationsVC ()

@end

@implementation CHPushNotificationsVC
@synthesize notificationsTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *menuCellIdentifier = @"notifications_cell";
    
    if (indexPath.section == 0) {
        CHPushNotificationsCell *cell = (CHPushNotificationsCell*) [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
        switch (indexPath.row) {
            case 0:
                cell.nameNotificationLabel.text = @"Alert me when I receive a message";
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
                break;
            case 1:
                cell.nameNotificationLabel.text = @"Alert me about new HOPs";
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
                break;
            case 2:
                cell.nameNotificationLabel.text = @"Alert me when sameone comments or likes my picks";
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
                break;
            case 3:
                cell.nameNotificationLabel.text = @"Alert me when I have a Friend Request";
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
                break;
            case 4:{
                cell.nameNotificationLabel.text = @"Alert me when a HOP is about to end if I have not completed it";
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
                break;
            }
            default:
                break;
            }
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
    CHPushNotificationsCell *cell = (CHPushNotificationsCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.indicatorImageView.image == [UIImage imageNamed:@"icon_indicator_on.png"]) {
        cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
    } else {
        cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setNotificationsTableView:nil];
    [super viewDidUnload];
}


@end
