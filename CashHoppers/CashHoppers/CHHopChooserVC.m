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

- (void) showInController:(UIView*) c {
    [c addSubview:self.view];
    self.view.frame = c.bounds;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dailyHopTapped:(id)sender {
    [self.view removeFromSuperview];
    
    DELEGATE.needOpenDailyHops = YES;
    [DELEGATE.tabBarController performSegueWithIdentifier:@"homeScreen" sender:nil];
}


- (IBAction)specialHopsTapped:(id)sender {
     [self.view removeFromSuperview];

    DELEGATE.needOpenOtherHops = YES;
    [DELEGATE.tabBarController performSegueWithIdentifier:@"homeScreen" sender:nil];
}


- (IBAction)closeTapped:(id)sender {
    [self.view removeFromSuperview];
}



@end
