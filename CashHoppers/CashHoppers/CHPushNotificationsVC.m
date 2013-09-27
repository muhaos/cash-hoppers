//
//  CHPushNotificationsVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/12/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHPushNotificationsVC.h"
#import "CHPushNotificationsCell.h"
#import "CHUserManager.h"

@interface CHPushNotificationsVC ()

@property (nonatomic, strong) NSArray* states;

@end

@implementation CHPushNotificationsVC
@synthesize notificationsTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    notificationsTableView.frame = CGRectMake(0, 0, 320, 220);
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([CHUserManager instance].userSettings == nil) {
        [[CHUserManager instance] updateUserSettingsWithCompletionBlock:^(NSError* error){
            [self.notificationsTableView reloadData];
        }];
    }
    
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

        NSDictionary* s = [CHUserManager instance].userSettings;

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
                cell.nameNotificationLabel.text = @"Alert me when someone comments or likes my picks";
                if ([[s objectForKey:@"comment_or_like"] boolValue]) {
                    cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
                } else {
                    cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
                }

                break;
            case 3:
                cell.nameNotificationLabel.text = @"Alert me when I have a Friend Request";
                
                if ([[s objectForKey:@"friend_invite"] boolValue]) {
                    cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
                } else {
                    cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
                }
                break;
            case 4:{
                cell.nameNotificationLabel.text = @"Alert me when a HOP is about to end if I have not completed it";
                
                if ([[s objectForKey:@"hop_about_to_end"] boolValue]) {
                    cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
                } else {
                    cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
                }
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
    if ([CHUserManager instance].userSettings == nil) {
        return nil;
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CHPushNotificationsCell *cell = (CHPushNotificationsCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableDictionary* s = [CHUserManager instance].userSettings;
    
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
            cell.nameNotificationLabel.text = @"Alert me when someone comments or likes my picks";
            [s setObject:@(![[s objectForKey:@"comment_or_like"] boolValue]) forKey:@"comment_or_like"];
            if ([[s objectForKey:@"comment_or_like"] boolValue]) {
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
            } else {
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
            }
            
            break;
        case 3:
            cell.nameNotificationLabel.text = @"Alert me when I have a Friend Request";

            [s setObject:@(![[s objectForKey:@"friend_invite"] boolValue]) forKey:@"friend_invite"];
            if ([[s objectForKey:@"friend_invite"] boolValue]) {
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
            } else {
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
            }
            break;
        case 4:{
            cell.nameNotificationLabel.text = @"Alert me when a HOP is about to end if I have not completed it";

            [s setObject:@(![[s objectForKey:@"hop_about_to_end"] boolValue]) forKey:@"hop_about_to_end"];
            if ([[s objectForKey:@"hop_about_to_end"] boolValue]) {
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_on.png"];
            } else {
                cell.indicatorImageView.image = [UIImage imageNamed:@"icon_indicator_off.png"];
            }
            break;
        }
        default:
            break;
    }
    
    [[CHUserManager instance] syncUserSettings];
    
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
