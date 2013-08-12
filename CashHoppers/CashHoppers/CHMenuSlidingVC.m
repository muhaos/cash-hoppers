//
//  CHMenuSlidingVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/10/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHMenuSlidingVC.h"
#import "ECSlidingViewController.h"
#import "CHMenuSlidingCell.h"
#import "CHAppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "CHAppDelegate.h"
#import "CHAPIClient.h"

@interface CHMenuSlidingVC () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation CHMenuSlidingVC
@synthesize menuTable;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slidingViewController setAnchorLeftRevealAmount:200.0f];
    self.slidingViewController.underLeftViewController = ECFullWidth;    
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
    return 5;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *menuCellIdentifier = @"menu_cell";
        
    if (indexPath.section == 0) {
        CHMenuSlidingCell *cell = (CHMenuSlidingCell*) [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
        switch (indexPath.row) {
            case 0:
                cell.label.text = @"Profile & Settings";
                cell.icon.image = [UIImage imageNamed:@"profile_icon.png"];
                break;
            case 1:
                cell.label.text = @"How To Play";
                cell.icon.image = [UIImage imageNamed:@"play_icon.png"];
                break;
            case 2:
                cell.label.text = @"FAQ";
                cell.icon.image = [UIImage imageNamed:@"question_icon.png"];
                break;
            case 3:
                cell.label.text = @"Find Friends";
                cell.icon.image = [UIImage imageNamed:@"find_icon.png"];
                break;
            case 4:{
                cell.label.text = @"Buy Ad Free Version";
                cell.icon.image = [UIImage imageNamed:@"buy_add_free_icon.png"];
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
    
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"profile_user" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"find_friends" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"ad_free_version" sender:self];
            break;
        default:
            break;
    }
    
       [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setMenuTable:nil];
    [super viewDidUnload];
}


- (IBAction)logoutButtonTapped:(id)sender
{
    NSError *error = nil;
    NSString* a_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"a_token"];
    //If no error we send the post, voila!
    if (!error){
        AFHTTPClient *client = [CHAPIClient sharedClient];
        NSString *path = [NSString stringWithFormat:@"/api/sessions/?auth_token=%@", a_token];
        NSMutableURLRequest *request = [client requestWithMethod:@"DELETE" path:path parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSString* errMsg = nil;
            if (JSON != nil) {
                errMsg = [JSON  objectForKey:@"info"];
            } else {
                errMsg = [error localizedDescription];
            }
            NSLog(@"Logout failed: %@", errMsg);
        }];
        
        [operation start];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"a_token"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    self.view.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"main_login_vc"];
}


@end
