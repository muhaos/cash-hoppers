//
//  CHHopChooserVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 6/28/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHHopChooserVC.h"
#import "CHAppDelegate.h"
#import "CHOtherHopsListVC.h"
#import "CHAppDelegate.h"
#import "MHCustomTabBarController.h"

@interface CHHopChooserVC ()

@end

@implementation CHHopChooserVC


+ (CHHopChooserVC*) sharedHopChooserVC {
    static CHHopChooserVC* instance = nil;
    if (instance == nil) {
        instance = [[CHHopChooserVC alloc] initWithNibName:@"CHHopChooserVC" bundle:nil];
    }
    return instance;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) showInController:(UIViewController*) c {
    [c.view addSubview:self.view];
    self.view.frame = c.view.bounds;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dailyHopTapped:(id)sender {
    //[DELEGATE switchViewTo:CHFeed];
    [self.view removeFromSuperview];
}


- (IBAction)specialHopsTapped:(id)sender {
//    [self.parentViewController presentModalViewController:otherHops animated:YES];\
//    [DELEGATE.tabBarController.container.= otherHops.view;
    //[DELEGATE.tabBarController performSegueWithIdentifier:@"otherHops" sender:[[UIButton alloc] init]];
     [self.view removeFromSuperview];

}


@end
