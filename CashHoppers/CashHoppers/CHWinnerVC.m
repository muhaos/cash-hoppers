//
//  CHWinnerVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/26/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHWinnerVC.h"
#import <QuartzCore/QuartzCore.h>

@interface CHWinnerVC ()

@property (assign, nonatomic) BOOL oldNavBarStatus;

@end

@implementation CHWinnerVC
@synthesize photoImageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    
    [photoImageView setImage:[UIImage imageNamed:@"photo_brian"]];
//    photoImageView.layer.cornerRadius = 70;
    photoImageView.clipsToBounds = YES;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDateLabel:nil];
    [self setNameLabel:nil];
    [self setDescrLabel:nil];
    [self setPhotoImageView:nil];
    [super viewDidUnload];
}
@end
