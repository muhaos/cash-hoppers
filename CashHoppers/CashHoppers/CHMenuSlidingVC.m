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
    return 4;
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
//    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:indexPath.row]];
//    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
//    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
//        CGRect frame = self.slidingViewController.topViewController.view.frame;
//        self.slidingViewController.topViewController = newTopViewController;
//        self.slidingViewController.topViewController.view.frame = frame;
//        [self.slidingViewController resetTopView];
//    }];
    
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

@end
