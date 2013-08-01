//
//  CHAddFriendsSocialNetworksVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/24/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHAddFriendsSocialNetworksVC.h"
#import "CHAddFriendsCell.h"
#import "CHStartVC.h"
#import "GPPSignIn.h"
#import "GTLPlus.h"
#import "GTMLogger.h"
#import "GTMOAuth2Authentication.h"
#import <QuartzCore/QuartzCore.h>

@interface CHAddFriendsSocialNetworksVC ()

@end

@implementation CHAddFriendsSocialNetworksVC
@synthesize friendsTable,peopleImageList, peopleList;


- (void)viewDidLoad
{
    [self reportAuthStatus];
    // Send Google+ request to get list of people that is visible to this app.
    [self listPeople:kGTLPlusCollectionVisible];

    [super viewDidLoad];
    [self setupTriangleBackButton];
}


- (void) backButtonTapped {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (peopleList == nil) {
		return 0;
	}
    return peopleList.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *friendsCellIdentifier = @"friends_list_cell";
    CHAddFriendsCell *cell = (CHAddFriendsCell*) [tableView dequeueReusableCellWithIdentifier:friendsCellIdentifier];
        
    if (indexPath.row < peopleList.count) {
        GTLPlusPerson *person = peopleList[indexPath.row];
        NSString *name = person.displayName;
        cell.nameLabel.text = name;
        if (indexPath.row < [peopleImageList count] && ![[peopleImageList objectAtIndex:indexPath.row] isEqual:[NSNull null]]) {
                cell.photoImageView.image = [[UIImage alloc] initWithData:[peopleImageList objectAtIndex:indexPath.row]];
        } else {
                cell.photoImageView.image = nil;
        }
    }
    
    [cell.photoImageView.layer setMasksToBounds:YES];
    [cell.photoImageView.layer setCornerRadius: 22.0f];
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/////////////////////////////////gooogle
- (void)listPeople:(NSString *)collection {
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
    plusService.retryEnabled = YES;
    
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];

    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleListWithUserId:@"me"
                                                          collection:kGTLPlusCollectionVisible];
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPeopleFeed *peopleFeed,
                                NSError *error) {
                if (error) {
                    GTMLoggerError(@"Error: %@", error);
                    NSLog(@"Status: Error: %@", error);
                } else {
                    peopleList = [peopleFeed.items retain];
                    [friendsTable reloadData];
                    NSNumber *count = peopleFeed.totalItems;
                    if (count.intValue == 1) {
                        NSLog(@"Status: Listed 1 person");
                    } else {
                        NSLog(@"Status: Listed %@ people", count);
                    }
                    [self fetchPeopleImages];
                }
            }];
}


- (void)fetchPeopleImages {
    NSInteger index = 0;
    peopleImageList =
    [[NSMutableArray alloc] initWithCapacity:[peopleList count]];
    for (GTLPlusPerson *person in peopleList) {
        NSString *imageURLString = person.image.url;
        if (imageURLString) {
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            [peopleImageList setObject:imageData atIndexedSubscript:index];
        } else {
            [peopleImageList setObject:[NSNull null] atIndexedSubscript:index];
        }
        ++index;
    }
}


- (void)reportAuthStatus {
    if (![GPPSignIn sharedInstance].authentication) {
        return;
    }
    if ([[GPPSignIn sharedInstance].scopes containsObject:
         kGTLAuthScopePlusLogin]) {
        NSLog(@"Status: Authenticated with plus.login scope");
    } else {
        // To authenticate, use Google+ sign-in button.
        NSLog( @"Status: Not authenticated with plus.login scope");
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setFriendsTable:nil];
    [self setHeaderLabel:nil];
    [super viewDidUnload];
}


@end
