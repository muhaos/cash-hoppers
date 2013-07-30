//
//  CHSelectedUserVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 7/29/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHSelectedUserVC.h"

@interface CHSelectedUserVC ()

@end

@implementation CHSelectedUserVC

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
}
@end
