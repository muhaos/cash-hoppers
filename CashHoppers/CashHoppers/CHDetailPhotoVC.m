//
//  CHDetailPhotoVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 9/26/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHDetailPhotoVC.h"
#import "CHAppDelegate.h"

@interface CHDetailPhotoVC ()

@end

@implementation CHDetailPhotoVC
@synthesize photoImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTriangleBackButton];
    photoImageView.image = _photoImage;
}

- (void) backButtonTapped {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
