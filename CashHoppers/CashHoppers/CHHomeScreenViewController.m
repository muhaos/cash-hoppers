//
//  CHHomeScreenViewController.m
//  CashHoppers
//
//  Created by Eugene on 21.06.13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHomeScreenViewController.h"

@interface CHHomeScreenViewController ()

@end

@implementation CHHomeScreenViewController

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
    [_scrollView setContentSize:CGSizeMake(340,470)];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidUnload {
    [self setBackButton:nil];
    [self setBannerImView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
